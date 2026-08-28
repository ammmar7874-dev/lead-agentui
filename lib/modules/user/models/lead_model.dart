class LeadModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String productOrService;
  final String status; // 'NEW', 'IN_PROGRESS', 'QUALIFIED', 'CLOSED'
  final String tag; // 'ORDER INQUIRY', 'FEATURE REQUEST', 'SUPPORT'
  final String budget;
  final String site;
  final DateTime capturedAt;

  const LeadModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.productOrService,
    required this.status,
    required this.tag,
    required this.budget,
    required this.site,
    required this.capturedAt,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['id'] ?? 'lead_${DateTime.now().millisecondsSinceEpoch}',
      name: json['name'] ?? 'Anonymous Visitor',
      email: json['email'] ?? 'info@univenture.work',
      phone: json['phone'] ?? '+1 (555) 019-2834',
      productOrService: json['productOrService'] ?? 'Basic Plan',
      status: json['status'] ?? 'NEW',
      tag: json['tag'] ?? 'ORDER INQUIRY',
      budget: json['budget'] ?? '\$1,500/mo',
      site: json['site'] ?? 'Excels_Tech Widget',
      capturedAt: json['capturedAt'] != null
          ? DateTime.parse(json['capturedAt'])
          : DateTime.now(),
    );
  }
}
