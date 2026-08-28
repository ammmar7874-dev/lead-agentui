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

class ChatMessageModel {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final List<CitationSource> citations;
  final bool isStreaming;
  final String? modelUsed;
  final int? tokens;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.citations = const [],
    this.isStreaming = false,
    this.modelUsed,
    this.tokens,
  });

  bool get isUser => sender == MessageSender.user;
  bool get isAssistant => sender == MessageSender.assistant;

  ChatMessageModel copyWith({
    String? id,
    String? text,
    MessageSender? sender,
    DateTime? timestamp,
    List<CitationSource>? citations,
    bool? isStreaming,
    String? modelUsed,
    int? tokens,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      citations: citations ?? this.citations,
      isStreaming: isStreaming ?? this.isStreaming,
      modelUsed: modelUsed ?? this.modelUsed,
      tokens: tokens ?? this.tokens,
    );
  }
}
