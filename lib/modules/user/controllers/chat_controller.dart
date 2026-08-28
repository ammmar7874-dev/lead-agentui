import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../models/chat_message_model.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();

  final TextEditingController inputController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Multi-Session Management
  final RxList<ChatSessionModel> sessions = <ChatSessionModel>[].obs;
  final RxString activeSessionId = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isBotTyping = false.obs;

  // Dropdown Options (From Reference Screenshots)
  final List<String> sourceModeOptions = const [
    'Auto',
    'Docs (RAG)',
    'Database',
    'App Live',
  ];

  final List<String> modelModeOptions = const [
    'Fast',
    'Balanced',
    'Best',
  ];

  // Active Modes
  final RxString currentSourceMode = 'Auto'.obs;
  final RxString currentModelMode = 'Balanced'.obs;
  final RxBool debugMode = false.obs;

  // Screen navigation state for mobile (List vs Chat)
  final RxBool isViewingChatDetail = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultSessions();
  }

  ChatSessionModel? get activeSession {
    if (sessions.isEmpty) return null;
    return sessions.firstWhereOrNull((s) => s.id == activeSessionId.value) ?? sessions.first;
  }

  List<ChatMessageModel> get currentMessages => activeSession?.messages ?? [];

  List<ChatSessionModel> get filteredSessions {
    if (searchQuery.value.trim().isEmpty) return sessions;
    final query = searchQuery.value.toLowerCase().trim();
    return sessions.where((s) => s.title.toLowerCase().contains(query) || s.lastMessagePreview.toLowerCase().contains(query)).toList();
  }

  void _initializeDefaultSessions() {
    final now = DateTime.now();

    final session1 = ChatSessionModel(
      id: 'sess_dfd',
      title: 'dfd',
      updatedAt: now.subtract(const Duration(minutes: 5)),
      sourceMode: 'Auto',
      modelMode: 'Balanced',
      messages: [
        ChatMessageModel(
          id: 'msg_w1',
          text: 'Hello! I am your AI RAG Assistant. Ask questions about your knowledge base.',
          sender: MessageSender.assistant,
          timestamp: now.subtract(const Duration(minutes: 5)),
          citations: const [
            CitationSource(
              title: 'excels-tech.ai/docs',
              snippet: 'Real-time multi-source retrieval augmented generation vector schema.',
              url: 'https://excelstech.ai/docs',
            ),
          ],
          modelUsed: 'GPT-4o (Balanced RAG)',
          tokens: 38,
        ),
      ],
    );

    final session2 = ChatSessionModel(
      id: 'sess_mvp',
      title: 'MVP Development Inquiry',
      updatedAt: now.subtract(const Duration(hours: 2)),
      sourceMode: 'Docs (RAG)',
      modelMode: 'Best',
      messages: [
        ChatMessageModel(
          id: 'msg_u1',
          text: 'How can you help me build a high-performance MVP?',
          sender: MessageSender.user,
          timestamp: now.subtract(const Duration(hours: 2)),
        ),
        ChatMessageModel(
          id: 'msg_a1',
          text: 'Our AI engineering team delivers production-ready MVPs within 4 to 6 weeks, including native Flutter cross-platform mobile apps, Supabase vector databases, and real-time LLM grounding.',
          sender: MessageSender.assistant,
          timestamp: now.subtract(const Duration(hours: 2)),
          citations: const [
            CitationSource(
              title: 'Services Matrix & Capabilities',
              snippet: 'Full stack development guidelines and SLAs for startups.',
              url: 'https://excelstech.ai/services/mvp',
            ),
          ],
          modelUsed: 'Claude 3.5 Sonnet (Deep RAG)',
          tokens: 64,
        ),
      ],
    );

    final session3 = ChatSessionModel(
      id: 'sess_pricing',
      title: 'Pricing & Custom Bot Plans',
      updatedAt: now.subtract(const Duration(days: 1)),
      sourceMode: 'Database',
      modelMode: 'Fast',
      messages: [
        ChatMessageModel(
          id: 'msg_u2',
          text: 'What is included in the Pro tier plan?',
          sender: MessageSender.user,
          timestamp: now.subtract(const Duration(days: 1)),
        ),
        ChatMessageModel(
          id: 'msg_a2',
          text: 'The Pro tier plan features up to 50,000 monthly conversations, custom CSS theme injection, 10 embed widget origins, and automated CRM lead capture via webhook.',
          sender: MessageSender.assistant,
          timestamp: now.subtract(const Duration(days: 1)),
          citations: const [
            CitationSource(
              title: 'Pricing & Tiers 2026',
              snippet: 'Enterprise and Pro tier specifications and token allowances.',
              url: 'https://excelstech.ai/pricing',
            ),
          ],
          modelUsed: 'GPT-4o Mini (Fast RAG)',
          tokens: 52,
        ),
      ],
    );

    sessions.assignAll([session1, session2, session3]);
    activeSessionId.value = session1.id;
    currentSourceMode.value = session1.sourceMode;
    currentModelMode.value = session1.modelMode;
    debugMode.value = session1.debugMode;
  }

  void createNewSession() {
    PlatformHelper.mediumHaptic();
    final newId = 'sess_${DateTime.now().millisecondsSinceEpoch}';
    final newSession = ChatSessionModel(
      id: newId,
      title: 'New Conversation',
      updatedAt: DateTime.now(),
      sourceMode: currentSourceMode.value,
      modelMode: currentModelMode.value,
      debugMode: debugMode.value,
      messages: [],
    );

    sessions.insert(0, newSession);
    activeSessionId.value = newId;
    isViewingChatDetail.value = true;
    inputController.clear();
    _scrollToBottom();
  }

  void selectSession(String id) {
    PlatformHelper.selectionHaptic();
    final session = sessions.firstWhereOrNull((s) => s.id == id);
    if (session != null) {
      activeSessionId.value = id;
      currentSourceMode.value = session.sourceMode;
      currentModelMode.value = session.modelMode;
      debugMode.value = session.debugMode;
      isViewingChatDetail.value = true;
      _scrollToBottom();
    }
  }

  void deleteSession(String id) {
    PlatformHelper.mediumHaptic();
    final index = sessions.indexWhere((s) => s.id == id);
    if (index != -1) {
      final removed = sessions.removeAt(index);
      if (activeSessionId.value == id) {
        if (sessions.isNotEmpty) {
          selectSession(sessions.first.id);
        } else {
          createNewSession();
        }
      }
      Get.snackbar(
        'Deleted',
        '"${removed.title}" deleted',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () {
            sessions.insert(index.clamp(0, sessions.length), removed);
            selectSession(removed.id);
          },
          child: const Text('Undo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    }
  }

  void backToSessionsList() {
    PlatformHelper.lightHaptic();
    isViewingChatDetail.value = false;
  }

  void setSourceMode(String mode) {
    currentSourceMode.value = mode;
    activeSession?.sourceMode = mode;
    PlatformHelper.selectionHaptic();
  }

  void setModelMode(String mode) {
    currentModelMode.value = mode;
    activeSession?.modelMode = mode;
    PlatformHelper.selectionHaptic();
  }

  void toggleDebugMode() {
    debugMode.toggle();
    activeSession?.debugMode = debugMode.value;
    PlatformHelper.selectionHaptic();
  }

  Future<void> sendMessage() async {
    final text = inputController.text.trim();
    if (text.isEmpty || isBotTyping.value) return;

    PlatformHelper.lightHaptic();
    final session = activeSession;
    if (session == null) return;

    // If first message and title is generic, update title to user prompt
    if (session.messages.isEmpty || session.title == 'New Conversation' || session.title == 'dfd') {
      final newTitle = text.length > 28 ? '${text.substring(0, 28)}...' : text;
      session.title = newTitle;
      sessions.refresh();
    }

    final userMessage = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    session.messages.add(userMessage);
    session.updatedAt = DateTime.now();
    sessions.refresh();
    inputController.clear();
    _scrollToBottom();

    // Trigger simulated RAG generation
    isBotTyping.value = true;
    await Future.delayed(const Duration(milliseconds: 500));

    final botMessageId = 'msg_${DateTime.now().millisecondsSinceEpoch + 1}';
    final responseText = _generateSimulatedRagResponse(text, currentSourceMode.value, currentModelMode.value);

    final words = responseText.split(' ');
    String currentOutput = '';

    final initialBotMessage = ChatMessageModel(
      id: botMessageId,
      text: '',
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      isStreaming: true,
      modelUsed: '${currentModelMode.value} (${currentSourceMode.value})',
      tokens: words.length * 2,
      citations: [
        CitationSource(
          title: 'Knowledge Source: ${currentSourceMode.value == "Docs (RAG)" ? "Synced PDFs & Manuals" : (currentSourceMode.value == "Database" ? "PostgreSQL Vector Store" : "Live App State")}',
          snippet: 'Grounded in knowledge base index with 0.96 cosine similarity.',
          url: 'https://excelstech.ai/sources',
          score: 0.96,
        ),
      ],
    );

    session.messages.add(initialBotMessage);
    sessions.refresh();
    _scrollToBottom();

    for (int i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 35));
      currentOutput += (i == 0 ? '' : ' ') + words[i];

      final msgIndex = session.messages.indexWhere((m) => m.id == botMessageId);
      if (msgIndex != -1) {
        session.messages[msgIndex] = session.messages[msgIndex].copyWith(
          text: currentOutput,
          isStreaming: i < words.length - 1,
        );
        sessions.refresh();
      }
      _scrollToBottom();
    }

    isBotTyping.value = false;
    PlatformHelper.mediumHaptic();
  }

  String _generateSimulatedRagResponse(String query, String source, String mode) {
    final q = query.toLowerCase();
    if (q.contains('mvp') || q.contains('develop')) {
      return 'Based on your [$source] knowledge base running on [$mode] mode, ExcelsTech delivers end-to-end MVP Development within 4-6 weeks with Flutter apps, Supabase vector databases, and production RAG pipelines.';
    } else if (q.contains('pricing') || q.contains('cost') || q.contains('plan')) {
      return 'According to [$source] specifications, custom plans start with a 14-day trial including unlimited queries, custom bot branding, multi-origin embeds, and live telemetry tracking.';
    } else if (q.contains('lead') || q.contains('visitor')) {
      return '[$source] automated capture detects visitor purchase intent in real-time, extracts contact info, and syncs directly with your CRM and email notifications.';
    } else {
      return 'Grounded response from [$source] ($mode mode): I have verified your query "$query" against the latest knowledge vectors. The data is synchronized and active across all connected web widgets.';
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
    PlatformHelper.mediumHaptic();
    activeSession?.messages.clear();
    sessions.refresh();
  }

  @override
  void onClose() {
    inputController.dispose();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
