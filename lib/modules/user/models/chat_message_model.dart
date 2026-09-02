enum MessageSender { user, assistant, system }

class CitationSource {
  final String title;
  final String snippet;
  final String? url;
  final double? score;

  const CitationSource({
    required this.title,
    required this.snippet,
    this.url,
    this.score = 0.92,
  });
}

class ChatAttachment {
  final String name;
  final String type; // 'pdf', 'doc', 'link', 'database'
  final String size;

  const ChatAttachment({
    required this.name,
    required this.type,
    required this.size,
  });
}

class ChatMessageModel {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final List<CitationSource> citations;
  final List<ChatAttachment> attachments;
  final bool isStreaming;
  final String? streamingStep;
  final String? modelUsed;
  final int? tokens;
  final int? latencyMs;
  final bool? isLiked; // true = up, false = down, null = none
  final bool isTtsPlaying;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.citations = const [],
    this.attachments = const [],
    this.isStreaming = false,
    this.streamingStep,
    this.modelUsed,
    this.tokens,
    this.latencyMs,
    this.isLiked,
    this.isTtsPlaying = false,
  });

  bool get isUser => sender == MessageSender.user;
  bool get isAssistant => sender == MessageSender.assistant;

  ChatMessageModel copyWith({
    String? id,
    String? text,
    MessageSender? sender,
    DateTime? timestamp,
    List<CitationSource>? citations,
    List<ChatAttachment>? attachments,
    bool? isStreaming,
    String? streamingStep,
    String? modelUsed,
    int? tokens,
    int? latencyMs,
    bool? isLiked,
    bool? isTtsPlaying,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      citations: citations ?? this.citations,
      attachments: attachments ?? this.attachments,
      isStreaming: isStreaming ?? this.isStreaming,
      streamingStep: streamingStep ?? this.streamingStep,
      modelUsed: modelUsed ?? this.modelUsed,
      tokens: tokens ?? this.tokens,
      latencyMs: latencyMs ?? this.latencyMs,
      isLiked: isLiked ?? this.isLiked,
      isTtsPlaying: isTtsPlaying ?? this.isTtsPlaying,
    );
  }
}

class ChatSessionModel {
  final String id;
  String title;
  DateTime updatedAt;
  List<ChatMessageModel> messages;
  String sourceMode;
  String modelMode;
  bool debugMode;
  bool isPinned;

  ChatSessionModel({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.messages,
    this.sourceMode = 'Auto',
    this.modelMode = 'Balanced',
    this.debugMode = false,
    this.isPinned = false,
  });

  String get lastMessagePreview {
    if (messages.isEmpty) return 'Start a new conversation';
    return messages.last.text;
  }
}

