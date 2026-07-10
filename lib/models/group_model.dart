import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String code;
  final String ownerId;
  final int members;
  final Timestamp createdAt;

  const GroupModel({
    required this.id,
    required this.name,
    required this.code,
    required this.ownerId,
    required this.members,
    required this.createdAt,
  });

  GroupModel copyWith({
    String? id,
    String? name,
    String? code,
    String? ownerId,
    int? members,
    Timestamp? createdAt,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'ownerId': ownerId,
      'members': members,
      'createdAt': createdAt,
    };
  }

  factory GroupModel.fromMap(String id, Map<String, dynamic> map) {
    return GroupModel(
      id: id,
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      ownerId: map['ownerId'] ?? '',
      members: map['members'] ?? 0,
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }
}