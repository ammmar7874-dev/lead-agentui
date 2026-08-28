import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../models/chat_message_model.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final RxBool isBotTyping = false.obs;
  final RxBool debugMode = false.obs;
  final RxString selectedModel = 'Balanced'.obs; // 'Auto', 'Balanced', 'Precise'

  final List<String> availableModels = ['Auto', 'Balanced', 'Precise'];

  @override
  void onInit() {
    super.onInit();
    _loadInitialWelcomeMessage();
  }

  void _loadInitialWelcomeMessage() {
    messages.add(
      ChatMessageModel(
        id: 'msg_welcome',
        text: 'Hello! I am your AI RAG Assistant. I have indexed your connected documents, website, and FAQs. How can I help you or test a query today?',
        sender: MessageSender.assistant,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        citations: const [
          CitationSource(
            title: 'AI RAG Knowledge Base Docs',
            snippet: 'Overview of conversational RAG vector index for excels-tech.ai',
            url: 'https://airagchatbot.com/sources/rag-docs',
          ),
        ],
        modelUsed: 'GPT-4o (RAG Hybrid)',
        tokens: 42,
      ),
    );
  }

  void setModel(String model) {
    selectedModel.value = model;
    PlatformHelper.selectionHaptic();
  }

  void toggleDebugMode() {
    debugMode.toggle();
    PlatformHelper.selectionHaptic();
  }

  Future<void> sendMessage() async {
    final text = inputController.text.trim();
    if (text.isEmpty || isBotTyping.value) return;

    PlatformHelper.lightHaptic();
    final userMessage = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    messages.add(userMessage);
    inputController.clear();
    _scrollToBottom();

    // Trigger AI streaming response
    isBotTyping.value = true;

    await Future.delayed(const Duration(milliseconds: 600));

    final botMessageId = 'msg_${DateTime.now().millisecondsSinceEpoch + 1}';
    final responseText = _generateSimulatedRagResponse(text);

    // Stream text word by word
    final words = responseText.split(' ');
    String currentOutput = '';

    final initialBotMessage = ChatMessageModel(
      id: botMessageId,
      text: '',
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      isStreaming: true,
      modelUsed: 'RAG ${selectedModel.value} Engine',
      tokens: words.length * 2,
      citations: [
        CitationSource(
          title: 'Knowledge Source: excels-tech.ai',
          snippet: 'Retrieved 3 matching chunks with cosine similarity 0.94.',
          url: 'https://excelstech.ai/services',
          score: 0.94,
        ),
      ],
    );

    messages.add(initialBotMessage);
    _scrollToBottom();

    for (int i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 45));
      currentOutput += (i == 0 ? '' : ' ') + words[i];

      final index = messages.indexWhere((m) => m.id == botMessageId);
      if (index != -1) {
        messages[index] = messages[index].copyWith(
          text: currentOutput,
          isStreaming: i < words.length - 1,
        );
      }
      _scrollToBottom();
    }

    isBotTyping.value = false;
    PlatformHelper.mediumHaptic();
  }

  String _generateSimulatedRagResponse(String query) {
    final q = query.toLowerCase();
    if (q.contains('mvp') || q.contains('develop')) {
      return 'Based on your connected Knowledge Source (AI SEO & ExcelsTech Docs), our team provides end-to-end MVP Development within 4-6 weeks, covering Flutter mobile apps, Next.js web dashboards, and AI pipeline integration.';
    } else if (q.contains('pricing') || q.contains('cost') || q.contains('plan')) {
      return 'According to your pricing matrix, the Basic Plan starts with a 14-day free trial, including up to 5,000 monthly conversations, custom bot branding, and CRM lead capture syncing.';
    } else if (q.contains('lead') || q.contains('visitor')) {
      return 'The bot automatically detects visitor inquiry intent during chat sessions, extracting contact emails, phone numbers, and budget estimates, then triggers live alerts via email and webhook.';
    } else {
      return 'I have retrieved relevant context from your synced documents regarding "$query". The knowledge base confirms this feature is supported across all connected embed widgets with 99.9% uptime and zero-latency vector search.';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  void clearConversation() {
    messages.clear();
    _loadInitialWelcomeMessage();
    PlatformHelper.mediumHaptic();
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
