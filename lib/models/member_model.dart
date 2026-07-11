import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  final String uid;
  final String username;
  final String role;
  final Timestamp joinedAt;
  final Timestamp lastResetAt;

  const MemberModel({
    required this.uid,
    required this.username,
    required this.role,
    required this.joinedAt,
    required this.lastResetAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'role': role,
      'joinedAt': joinedAt,
      'lastResetAt': lastResetAt,
    };
  }

  factory MemberModel.fromMap(
    String uid,
    Map<String, dynamic> map,
  ) {
    return MemberModel(
      uid: uid,
      username: map['username'] ?? '',
      role: map['role'] ?? 'member',
      joinedAt: map['joinedAt'] ?? Timestamp.now(),
      lastResetAt: map['lastResetAt'] ?? Timestamp.now(),
    );
  }

  MemberModel copyWith({
    String? uid,
    String? username,
    String? role,
    Timestamp? joinedAt,
    Timestamp? lastResetAt,
  }) {
    return MemberModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      lastResetAt: lastResetAt ?? this.lastResetAt,
    );
  }

  int get streakDays {
    final reset = lastResetAt.toDate();

    final now = DateTime.now();

    return now.difference(reset).inDays;
  }
}