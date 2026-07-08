class GroupModel {
  final String id;
  final String name;
  final String code;
  final int members;

  const GroupModel({
    required this.id,
    required this.name,
    required this.code,
    required this.members,
  });

  GroupModel copyWith({
    String? id,
    String? name,
    String? code,
    int? members,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      members: members ?? this.members,
    );
  }
}