class KnowledgeSourceModel {
  final String id;
  final String title;
  final String type; // 'Website', 'PDF', 'FAQ', 'API'
  final int documentCount;
  final int chunkCount;
  final String syncStatus; // 'SUCCEEDED', 'SYNCING', 'FAILED', 'IDLE'
  final bool autoSync;
  final String syncInterval; // '24 hours', '12 hours', '1 hour'
  final DateTime lastSync;
  final DateTime nextSync;

  const KnowledgeSourceModel({
    required this.id,
    required this.title,
    required this.type,
    required this.documentCount,
    required this.chunkCount,
    required this.syncStatus,
    required this.autoSync,
    required this.syncInterval,
    required this.lastSync,
    required this.nextSync,
  });

  KnowledgeSourceModel copyWith({
    String? id,
    String? title,
    String? type,
    int? documentCount,
    int? chunkCount,
    String? syncStatus,
    bool? autoSync,
    String? syncInterval,
    DateTime? lastSync,
    DateTime? nextSync,
  }) {
    return KnowledgeSourceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      documentCount: documentCount ?? this.documentCount,
      chunkCount: chunkCount ?? this.chunkCount,
      syncStatus: syncStatus ?? this.syncStatus,
      autoSync: autoSync ?? this.autoSync,
      syncInterval: syncInterval ?? this.syncInterval,
      lastSync: lastSync ?? this.lastSync,
      nextSync: nextSync ?? this.nextSync,
    );
  }
}
