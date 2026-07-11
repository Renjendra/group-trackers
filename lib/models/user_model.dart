import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final Timestamp createdAt;

  const UserModel({
    required this.uid,
    required this.username,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return UserModel(
      uid: id,
      username: map['username'],
      createdAt: map['createdAt'],
    );
  }
}