import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  final String uid;
  final String username;
  final int streak;
  final String role;
  final Timestamp joinedAt;

  const MemberModel({
    required this.uid,
    required this.username,
    required this.streak,
    required this.role,
    required this.joinedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'streak': streak,
      'role': role,
      'joinedAt': joinedAt,
    };
  }

  factory MemberModel.fromMap(
    String uid,
    Map<String, dynamic> map,
  ) {
    return MemberModel(
      uid: uid,
      username: map['username'] ?? '',
      streak: map['streak'] ?? 0,
      role: map['role'] ?? 'member',
      joinedAt: map['joinedAt'] ?? Timestamp.now(),
    );
  }

  MemberModel copyWith({
    String? uid,
    String? username,
    int? streak,
    String? role,
    Timestamp? joinedAt,
  }) {
    return MemberModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      streak: streak ?? this.streak,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}