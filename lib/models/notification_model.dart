import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;

  final String groupId;

  // Member yang gagal
  final String uid;

  // Username member yang gagal
  final String username;

  // Penerima notifikasi
  final String receiverUid;

  final int streak;

  final Timestamp createdAt;

  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.groupId,
    required this.uid,
    required this.username,
    required this.receiverUid,
    required this.streak,
    required this.createdAt,
    required this.isRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'uid': uid,
      'username': username,
      'receiverUid': receiverUid,
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
      receiverUid: map['receiverUid'],
      streak: map['streak'],
      createdAt: map['createdAt'],
      isRead: map['isRead'] ?? false,
    );
  }
}