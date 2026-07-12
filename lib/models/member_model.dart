import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  final String uid;
  final String username;
  final String role;
  final Timestamp joinedAt;
  final Timestamp lastResetAt;

  // NEW
  final int bestStreak;

  const MemberModel({
    required this.uid,
    required this.username,
    required this.role,
    required this.joinedAt,
    required this.lastResetAt,
    required this.bestStreak,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'role': role,
      'joinedAt': joinedAt,
      'lastResetAt': lastResetAt,
      'bestStreak': bestStreak,
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
      bestStreak: map['bestStreak'] ?? 0,
    );
  }

  MemberModel copyWith({
    String? uid,
    String? username,
    String? role,
    Timestamp? joinedAt,
    Timestamp? lastResetAt,
    int? bestStreak,
  }) {
    return MemberModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      lastResetAt: lastResetAt ?? this.lastResetAt,
      bestStreak: bestStreak ?? this.bestStreak,
    );
  }

  int get streakDays {
    final reset = lastResetAt.toDate();
    return DateTime.now().difference(reset).inDays;
  }
}