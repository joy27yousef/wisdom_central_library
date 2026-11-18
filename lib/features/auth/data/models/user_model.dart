import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wisdom_central_library/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.role,
    super.isEmailVerified,
    required super.phone,
    required super.stage,
    required super.branch,
    super.createdAt,
  });

  factory UserModel.fromMap(
    Map<String, dynamic> map,
    String id, {
    bool isEmailVerified = false,
  }) {
    DateTime? parsedCreatedAt;
    final rawCreatedAt = map['createdAt'];
    if (rawCreatedAt is Timestamp) {
      parsedCreatedAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      parsedCreatedAt = DateTime.tryParse(rawCreatedAt);
    }

    return UserModel(
      uid: id,
      email: (map['email'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      role: (map['role'] as String?) ?? 'user',
      isEmailVerified: isEmailVerified,
      phone: (map['phone'] as String?) ?? '',
      stage: (map['stage'] as String?) ?? '',
      branch: (map['branch'] as String?) ?? '',
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'phone': phone,
      'stage': stage,
      'branch': branch,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
