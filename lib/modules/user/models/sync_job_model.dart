class SyncJobModel {
  final String id;
  final String sourceTitle;
  final DateTime executedAt;
  final String duration;
  final int pages;
  final int docs;
  final int chunks;
  final int embedded;
  final String status; // 'SUCCEEDED', 'FAILED', 'IN_PROGRESS'
  final String? errorMessage;

  const SyncJobModel({
    required this.id,
    required this.sourceTitle,
    required this.executedAt,
    required this.duration,
    required this.pages,
    required this.docs,
    required this.chunks,
    required this.embedded,
    required this.status,
    this.errorMessage,
  });
}
