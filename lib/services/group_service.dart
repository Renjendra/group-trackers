import '../models/group_model.dart';

class GroupService {
  GroupService._internal();

  static final GroupService instance = GroupService._internal();

  factory GroupService() => instance;

  final List<GroupModel> _groups = [];

  List<GroupModel> get groups => _groups;

  void addGroup(GroupModel group) {
    _groups.add(group);
  }

  void removeGroup(String id) {
    _groups.removeWhere((group) => group.id == id);
  }

  void updateGroup(GroupModel group) {
    final index = _groups.indexWhere((g) => g.id == group.id);

    if (index != -1) {
      _groups[index] = group;
    }
  }
}