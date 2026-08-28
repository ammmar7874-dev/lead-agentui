class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role; // 'ADMIN', 'EDITOR', 'VIEWER'
  final String organizationName;
  final String? token;
  final bool isMfaEnabled;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role = 'ADMIN',
    this.organizationName = 'Excels Tech',
    this.token,
    this.isMfaEnabled = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 'user_1',
      name: json['name'] ?? 'Zia',
      email: json['email'] ?? 'zia@excels-tech.com',
      avatarUrl: json['avatarUrl'],
      role: json['role'] ?? 'ADMIN',
      organizationName: json['organizationName'] ?? 'Excels Tech',
      token: json['token'],
      isMfaEnabled: json['isMfaEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role,
      'organizationName': organizationName,
      'token': token,
      'isMfaEnabled': isMfaEnabled,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? role,
    String? organizationName,
    String? token,
    bool? isMfaEnabled,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      organizationName: organizationName ?? this.organizationName,
      token: token ?? this.token,
      isMfaEnabled: isMfaEnabled ?? this.isMfaEnabled,
    );
  }
}
