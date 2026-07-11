import 'package:flutter/material.dart';

import '../models/group_model.dart';
import '../models/member_model.dart';
import '../services/firestore_service.dart';

class GroupTrackerProvider extends ChangeNotifier {
  final FirestoreService firestoreService = FirestoreService();

  List<MemberModel> members = [];

  bool isLoading = true;

  Future<void> loadMembers(
    GroupModel group,
  ) async {
    firestoreService
        .getMembers(group.id)
        .listen((event) {
      members = event;

      members.sort(
        (a, b) =>
            b.streakDays.compareTo(a.streakDays),
      );

      isLoading = false;

      notifyListeners();
    });
  }
}