import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String groupId;
  final String uid;
  final String username;
  final int streak;
  final Timestamp createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.groupId,
    required this.uid,
    required this.username,
    required this.streak,
    required this.createdAt,
    required this.isRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'uid': uid,
      'username': username,
      'streak': streak,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return NotificationModel(
      id: id,
      groupId: map['groupId'],
      uid: map['uid'],
      username: map['username'],
      streak: map['streak'],
      createdAt: map['createdAt'],
      isRead: map['isRead'] ?? false,
    );
  }
}