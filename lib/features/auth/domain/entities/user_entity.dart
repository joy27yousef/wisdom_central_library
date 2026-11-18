class UserEntity {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String phone;
  final String stage;
  final String branch;
  final bool isEmailVerified;
  final DateTime? createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.isEmailVerified = false,
    required this.phone,
    required this.stage,
    required this.branch,
    this.createdAt,
  });

  bool get isProfileComplete {
    return name.trim().isNotEmpty &&
        phone.trim().isNotEmpty &&
        stage.trim().isNotEmpty &&
        branch.trim().isNotEmpty;
  }

  UserEntity copyWith({
    String? uid,
    String? email,
    String? name,
    String? role,
    String? phone,
    String? stage,
    String? branch,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      stage: stage ?? this.stage,
      branch: branch ?? this.branch,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
