import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/native/platform_helper.dart';
import '../models/chat_message_model.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();

  final TextEditingController inputController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode inputFocusNode = FocusNode();

  // Multi-Session Management
  final RxList<ChatSessionModel> sessions = <ChatSessionModel>[].obs;
  final RxString activeSessionId = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isBotTyping = false.obs;
  final RxBool isRecordingVoice = false.obs;
  final RxInt recordingSeconds = 0.obs;
  Timer? _recordingTimer;
  Timer? _streamingTimer;
  bool _shouldCancelStreaming = false;

  // Attached files/sources for the next prompt
  final RxList<ChatAttachment> pendingAttachments = <ChatAttachment>[].obs;

  // Dropdown Options
  final List<String> sourceModeOptions = const [
    'Auto (RAG)',
    'Docs Store',
    'Vector DB',
    'Live App',
    'Web Search',
  ];

  final List<String> modelModeOptions = const [
    'Fast (Mini)',
    'Balanced (4o)',
    'Deep (Claude)',
    'Pro (Gemini)',
  ];

  // Active Modes
  final RxString currentSourceMode = 'Auto (RAG)'.obs;
  final RxString currentModelMode = 'Balanced (4o)'.obs;
  final RxBool debugMode = false.obs;
  final RxBool showCitationsDrawer = false.obs;
  final Rx<CitationSource?> selectedCitation = Rx<CitationSource?>(null);

  // Quick Inspiration Prompts
  final List<Map<String, dynamic>> quickPrompts = const [
    {
      'icon': Icons.layers_rounded,
      'title': 'RAG Architecture',
      'prompt': 'Explain how vector embedding and semantic retrieval work in this chatbot.',
      'tag': 'Architecture',
    },
    {
      'icon': Icons.code_rounded,
      'title': 'Widget Embed Code',
      'prompt': 'Generate the HTML script tag and iframe snippet for integrating the AI chatbot widget.',
      'tag': 'Integration',
    },
    {
      'icon': Icons.storage_rounded,
      'title': 'Database Sync Status',
      'prompt': 'Show the current vector synchronization stats and PostgreSQL connection pool status.',
      'tag': 'Database',
    },
    {
      'icon': Icons.monetization_on_rounded,
      'title': 'Pricing & ROI Estimate',
      'prompt': 'Break down the monthly token consumption cost and estimated conversion ROI.',
      'tag': 'Billing',
    },
    {
      'icon': Icons.security_rounded,
      'title': 'Data Privacy & SOC2',
      'prompt': 'Are documents sanitized before being processed by the LLM embedding pipeline?',
      'tag': 'Security',
    },
  ];

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
    var list = sessions.toList();
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase().trim();
      list = list.where((s) =>
        s.title.toLowerCase().contains(query) ||
        s.lastMessagePreview.toLowerCase().contains(query)
      ).toList();
    }
    // Sort: Pinned first, then newest updated
    list.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return list;
  }

  void _initializeDefaultSessions() {
    final now = DateTime.now();

    final session1 = ChatSessionModel(
      id: 'sess_welcome',
      title: 'RAG Architecture & Schema',
      isPinned: true,
      updatedAt: now.subtract(const Duration(minutes: 4)),
      sourceMode: 'Auto (RAG)',
      modelMode: 'Balanced (4o)',
      messages: [
        ChatMessageModel(
          id: 'msg_w1',
          text: 'Hello! I am your AI RAG Engine. I ground answers directly in your connected documents, PostgreSQL vectors, and live website visitors in real-time.\n\nHow can I help optimize your AI pipeline today?',
          sender: MessageSender.assistant,
          timestamp: now.subtract(const Duration(minutes: 4)),
          citations: const [
            CitationSource(
              title: 'knowledge-core-v2.pdf',
              snippet: 'Enterprise hybrid vector retrieval pipeline using pgvector and cosine distance ranking at 0.98 similarity.',
              url: 'https://excelstech.ai/docs/rag-architecture',
              score: 0.98,
            ),
            CitationSource(
              title: 'schema_sync_config.json',
              snippet: 'Real-time multi-tenant database synchronization and automated chunking rules.',
              url: 'https://excelstech.ai/docs/schema',
              score: 0.94,
            ),
          ],
          modelUsed: 'GPT-4o (Balanced RAG)',
          tokens: 42,
          latencyMs: 142,
        ),
      ],
    );

    final session2 = ChatSessionModel(
      id: 'sess_widget',
      title: 'Embed Script & Customization',
      updatedAt: now.subtract(const Duration(hours: 1, minutes: 20)),
      sourceMode: 'Docs Store',
      modelMode: 'Deep (Claude)',
      messages: [
        ChatMessageModel(
          id: 'msg_u2',
          text: 'Can you show me how to embed this chatbot on our landing page with custom branding?',
          sender: MessageSender.user,
          timestamp: now.subtract(const Duration(hours: 1, minutes: 20)),
        ),
        ChatMessageModel(
          id: 'msg_a2',
          text: 'Here is the ultra-lightweight client script to embed the AI widget directly on any website:\n\n```html\n<!-- AI RAG ChatBot Widget -->\n<script \n  src="https://cdn.airagchatbot.com/v2/widget.js"\n  data-agent-id="agent_prod_8829"\n  data-theme="dark"\n  data-primary-color="#C8102E"\n  defer>\n</script>\n```\n\n### Key Highlights:\n- **Zero Latency:** Loads asynchronously under 12KB.\n- **Session Persistence:** Remembers returning visitors automatically.\n- **Lead Capture:** Gathers visitor email and webhook pushes instantly.',
          sender: MessageSender.assistant,
          timestamp: now.subtract(const Duration(hours: 1, minutes: 19)),
          citations: const [
            CitationSource(
              title: 'Web Widget Developer SDK',
              snippet: 'Embed instructions and custom CSS overrides for frontend teams.',
              url: 'https://excelstech.ai/docs/widget',
              score: 0.96,
            ),
          ],
          modelUsed: 'Claude 3.5 Sonnet (Deep RAG)',
          tokens: 96,
          latencyMs: 310,
        ),
      ],
    );

    final session3 = ChatSessionModel(
      id: 'sess_pricing',
      title: 'Pricing & Token Economics',
      updatedAt: now.subtract(const Duration(days: 1)),
      sourceMode: 'Vector DB',
      modelMode: 'Fast (Mini)',
      messages: [
        ChatMessageModel(
          id: 'msg_u3',
          text: 'What is our token limit and how are conversations billed?',
          sender: MessageSender.user,
          timestamp: now.subtract(const Duration(days: 1)),
        ),
        ChatMessageModel(
          id: 'msg_a3',
          text: 'On the Enterprise tier, you receive **1,000,000 monthly vector query tokens** and unlimited widget origins. Additional queries cost **\$0.0015 per 1k grounded tokens** with zero compute markup.',
          sender: MessageSender.assistant,
          timestamp: now.subtract(const Duration(days: 1)),
          citations: const [
            CitationSource(
              title: 'Pricing Matrix 2026',
              snippet: 'Enterprise SLAs, token pricing tables, and dedicated vector replicas.',
              url: 'https://excelstech.ai/pricing',
              score: 0.92,
            ),
          ],
          modelUsed: 'GPT-4o Mini (Fast RAG)',
          tokens: 58,
          latencyMs: 88,
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
    pendingAttachments.clear();
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
      pendingAttachments.clear();
      _scrollToBottom();
    }
  }

  void togglePinSession(String id) {
    PlatformHelper.selectionHaptic();
    final session = sessions.firstWhereOrNull((s) => s.id == id);
    if (session != null) {
      session.isPinned = !session.isPinned;
      sessions.refresh();
    }
  }

  void renameSession(String id, String newTitle) {
    if (newTitle.trim().isEmpty) return;
    final session = sessions.firstWhereOrNull((s) => s.id == id);
    if (session != null) {
      session.title = newTitle.trim();
      sessions.refresh();
      PlatformHelper.lightHaptic();
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
        duration: const Duration(seconds: 4),
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

  void openCitationDetail(CitationSource citation) {
    selectedCitation.value = citation;
    showCitationsDrawer.value = true;
    PlatformHelper.lightHaptic();
  }

  void closeCitationDetail() {
    showCitationsDrawer.value = false;
  }

  // Attachments support
  void addSampleAttachment(String type) {
    PlatformHelper.lightHaptic();
    if (type == 'pdf') {
      pendingAttachments.add(const ChatAttachment(
        name: 'Company_Knowledge_Base_2026.pdf',
        type: 'pdf',
        size: '2.4 MB',
      ));
    } else if (type == 'database') {
      pendingAttachments.add(const ChatAttachment(
        name: 'PostgreSQL_Vector_Index',
        type: 'database',
        size: '18.2k vectors',
      ));
    } else {
      pendingAttachments.add(const ChatAttachment(
        name: 'https://excelstech.ai/api/v1/schema',
        type: 'link',
        size: 'Live Endpoint',
      ));
    }
  }

  void removeAttachment(int index) {
    if (index >= 0 && index < pendingAttachments.length) {
      pendingAttachments.removeAt(index);
      PlatformHelper.lightHaptic();
    }
  }

  // Voice recording simulation
  void toggleVoiceRecording() {
    PlatformHelper.mediumHaptic();
    if (isRecordingVoice.value) {
      // Stop recording and insert transcribed query
      _recordingTimer?.cancel();
      isRecordingVoice.value = false;
      inputController.text = 'Summarize key customer insights from live visitor interactions';
      inputFocusNode.requestFocus();
    } else {
      isRecordingVoice.value = true;
      recordingSeconds.value = 0;
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        recordingSeconds.value++;
      });
    }
  }

  // Quick Prompt Execution
  void applyQuickPrompt(String promptText) {
    inputController.text = promptText;
    sendMessage();
  }

  // Message Reaction Feedback
  void toggleMessageReaction(String messageId, bool isLiked) {
    PlatformHelper.lightHaptic();
    final session = activeSession;
    if (session == null) return;
    final index = session.messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final current = session.messages[index];
      final newLiked = (current.isLiked == isLiked) ? null : isLiked;
      session.messages[index] = current.copyWith(isLiked: newLiked);
      sessions.refresh();
    }
  }

  // Message Text Copy Feedback
  void copyMessageText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    PlatformHelper.lightHaptic();
    Get.rawSnackbar(
      message: 'Copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xFF1E293B),
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
    );
  }

  // Text-To-Speech (TTS) simulation toggle
  void toggleTts(String messageId) {
    PlatformHelper.lightHaptic();
    final session = activeSession;
    if (session == null) return;
    for (int i = 0; i < session.messages.length; i++) {
      if (session.messages[i].id == messageId) {
        final currentPlay = session.messages[i].isTtsPlaying;
        session.messages[i] = session.messages[i].copyWith(isTtsPlaying: !currentPlay);
      } else if (session.messages[i].isTtsPlaying) {
        session.messages[i] = session.messages[i].copyWith(isTtsPlaying: false);
      }
    }
    sessions.refresh();
  }

  // Stop Generation
  void stopGenerating() {
    _shouldCancelStreaming = true;
    _streamingTimer?.cancel();
    isBotTyping.value = false;
    PlatformHelper.mediumHaptic();
    final session = activeSession;
    if (session != null && session.messages.isNotEmpty) {
      final lastMsg = session.messages.last;
      if (lastMsg.isStreaming) {
        session.messages[session.messages.length - 1] = lastMsg.copyWith(
          isStreaming: false,
          streamingStep: 'Generation stopped',
        );
        sessions.refresh();
      }
    }
  }

  // Regenerate Response
  void regenerateLastResponse() {
    final session = activeSession;
    if (session == null || session.messages.isEmpty || isBotTyping.value) return;

    // Find last user prompt
    ChatMessageModel? lastUserMsg;
    for (int i = session.messages.length - 1; i >= 0; i--) {
      if (session.messages[i].isUser) {
        lastUserMsg = session.messages[i];
        break;
      }
    }
    if (lastUserMsg == null) return;

    // Remove last assistant message if exists
    if (session.messages.last.isAssistant) {
      session.messages.removeLast();
      sessions.refresh();
    }

    _triggerBotGeneration(lastUserMsg.text);
  }

  // Send User Message
  Future<void> sendMessage() async {
    final text = inputController.text.trim();
    if (text.isEmpty || isBotTyping.value) return;

    PlatformHelper.lightHaptic();
    final session = activeSession;
    if (session == null) return;

    // Update title if needed
    if (session.messages.isEmpty || session.title == 'New Conversation') {
      final cleanTitle = text.replaceAll('\n', ' ').trim();
      session.title = cleanTitle.length > 28 ? '${cleanTitle.substring(0, 28)}...' : cleanTitle;
      sessions.refresh();
    }

    final currentAttachments = List<ChatAttachment>.from(pendingAttachments);
    final userMessage = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      attachments: currentAttachments,
    );

    session.messages.add(userMessage);
    session.updatedAt = DateTime.now();
    sessions.refresh();
    inputController.clear();
    pendingAttachments.clear();
    _scrollToBottom();

    await _triggerBotGeneration(text);
  }

  Future<void> _triggerBotGeneration(String prompt) async {
    final session = activeSession;
    if (session == null) return;

    isBotTyping.value = true;
    _shouldCancelStreaming = false;

    final botMessageId = 'msg_${DateTime.now().millisecondsSinceEpoch + 1}';
    final responseText = _generateSimulatedRagResponse(prompt, currentSourceMode.value, currentModelMode.value);
    final words = responseText.split(' ');

    // Initial streaming message
    final initialBotMessage = ChatMessageModel(
      id: botMessageId,
      text: '',
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      isStreaming: true,
      streamingStep: '🔍 Querying vector index...',
      modelUsed: '${currentModelMode.value.split(' ').first} · ${currentSourceMode.value.split(' ').first}',
      tokens: (words.length * 1.8).round(),
      latencyMs: 120 + (words.length * 3),
      citations: [
        CitationSource(
          title: currentSourceMode.value.contains('Docs')
              ? 'enterprise_knowledge_base.pdf'
              : (currentSourceMode.value.contains('Database') ? 'pgvector_semantic_index' : 'live_rag_telemetry.json'),
          snippet: 'Grounded vector match with 0.97 Cosine Similarity against query terms: "$prompt".',
          url: 'https://excelstech.ai/rag-source',
          score: 0.97,
        ),
        if (prompt.toLowerCase().contains('code') || prompt.toLowerCase().contains('embed') || prompt.toLowerCase().contains('widget'))
          const CitationSource(
            title: 'widget_client_sdk_v2.md',
            snippet: 'Embed parameters, lifecycle callbacks, theme tokens, and cross-origin iframe security.',
            url: 'https://excelstech.ai/docs/widget-sdk',
            score: 0.94,
          ),
      ],
    );

    session.messages.add(initialBotMessage);
    sessions.refresh();
    _scrollToBottom();

    // Multi-step ticker
    final steps = [
      '🔍 Searching vector embeddings...',
      '⚡ Reranking semantic chunks...',
      '🧠 Synthesizing grounded response...',
    ];

    for (int s = 0; s < steps.length; s++) {
      if (_shouldCancelStreaming) return;
      await Future.delayed(const Duration(milliseconds: 220));
      final msgIndex = session.messages.indexWhere((m) => m.id == botMessageId);
      if (msgIndex != -1) {
        session.messages[msgIndex] = session.messages[msgIndex].copyWith(
          streamingStep: steps[s],
        );
        sessions.refresh();
      }
    }

    String currentOutput = '';
    for (int i = 0; i < words.length; i++) {
      if (_shouldCancelStreaming) return;
      await Future.delayed(const Duration(milliseconds: 24));
      currentOutput += (i == 0 ? '' : ' ') + words[i];

      final msgIndex = session.messages.indexWhere((m) => m.id == botMessageId);
      if (msgIndex != -1) {
        session.messages[msgIndex] = session.messages[msgIndex].copyWith(
          text: currentOutput,
          isStreaming: i < words.length - 1,
          streamingStep: i < words.length - 1 ? '✨ Generating tokens...' : null,
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

    if (q.contains('code') || q.contains('embed') || q.contains('script') || q.contains('widget')) {
      return 'Here is the production-ready script snippet to embed your custom AI RAG assistant into any frontend:\n\n```html\n<script\n  src="https://cdn.airagchatbot.com/v2/widget.js"\n  data-org-id="org_892348"\n  data-primary-color="#C8102E"\n  data-position="bottom-right"\n  async>\n</script>\n```\n\n### Integration Steps:\n1. **Inject Snippet:** Paste into your HTML `<body>` or Google Tag Manager.\n2. **Grounding Active:** The bot automatically queries your synchronized `$source` knowledge base.\n3. **Telemetry:** All user conversations stream directly to your Live Activity dashboard.';
    } else if (q.contains('rag') || q.contains('architecture') || q.contains('vector') || q.contains('semantic')) {
      return 'Our enterprise RAG architecture is engineered for sub-200ms grounded generation:\n\n- **Chunking Strategy:** Recursive character splitting (512 tokens with 64 token overlap).\n- **Vector Embeddings:** 1536-dimensional semantic vectors indexed with HNSW in PostgreSQL pgvector.\n- **Hybrid Search:** Combines BM25 full-text keyword indexing with dense vector similarity.\n- **Source Grounding:** Current active mode is **$source** with model engine **$mode**.';
    } else if (q.contains('pricing') || q.contains('cost') || q.contains('token') || q.contains('plan') || q.contains('billing')) {
      return 'Based on your billing configuration in **$source**:\n\n- **Pro Tier:** \$49/month includes 500,000 grounded tokens and 5 custom knowledge bases.\n- **Enterprise Tier:** \$199/month includes dedicated vector replica, custom webhook pipeline, and unlimited seat access.\n- **Token Efficiency:** The prompt engine compresses knowledge contexts to maximize query throughput by 42%.';
    } else if (q.contains('database') || q.contains('sql') || q.contains('sync')) {
      return '### Database & Vector Store Status:\n- **Vector Nodes:** 18,450 synchronized chunks.\n- **Replication Lag:** 14ms (Optimal).\n- **Cosine Match Threshold:** 0.85 (High Precision).\n- **Active Source:** Connected to PostgreSQL with pgvector indexing.';
    } else {
      return 'Grounded response via **$source** ($mode):\n\nI have cross-referenced your query **"$query"** across all indexed knowledge documents and verified semantic relevance. The system is operating in real-time mode with live multi-turn context memory.';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 280),
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

  void exportTranscript() {
    final session = activeSession;
    if (session == null || session.messages.isEmpty) return;

    final buffer = StringBuffer();
    buffer.writeln('# AI RAG Chat Transcript: ${session.title}');
    buffer.writeln('Date: ${session.updatedAt.toIso8601String()}');
    buffer.writeln('Model: ${session.modelMode} | Source: ${session.sourceMode}\n---\n');

    for (final m in session.messages) {
      final senderName = m.isUser ? 'User' : 'AI Assistant';
      buffer.writeln('### $senderName (${m.timestamp.hour}:${m.timestamp.minute.toString().padLeft(2, '0')})');
      buffer.writeln(m.text);
      if (m.citations.isNotEmpty) {
        buffer.writeln('\n*Citations:*');
        for (final c in m.citations) {
          buffer.writeln('- ${c.title} (${(c.score ?? 0.9) * 100}%): ${c.snippet}');
        }
      }
      buffer.writeln('\n---\n');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    PlatformHelper.mediumHaptic();
    Get.snackbar(
      'Exported to Clipboard',
      'Markdown transcript of "${session.title}" ready to paste.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    _recordingTimer?.cancel();
    _streamingTimer?.cancel();
    inputController.dispose();
    searchController.dispose();
    scrollController.dispose();
    inputFocusNode.dispose();
    super.onClose();
  }
}
