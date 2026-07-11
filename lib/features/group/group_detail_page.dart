import 'package:flutter/material.dart';

import '../../models/group_model.dart';
import '../../services/firestore_service.dart';

import 'edit_group_page.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../models/member_model.dart';

import '../../shared/widgets/streak_card.dart';
import '../../shared/widgets/failed_button.dart';
import '../../shared/widgets/leaderboard_card.dart';

class GroupDetailPage extends StatefulWidget {
  final GroupModel group;

  const GroupDetailPage({
    super.key,
    required this.group,
  });

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  late GroupModel group;

  final FirestoreService firestoreService = FirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    group = widget.group;
  }

  Future<void> deleteGroup() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Group"),
          content: const Text(
            "Are you sure you want to delete this group?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await firestoreService.deleteGroup(group.id);

    if (!mounted) return;

    Navigator.pop(context);
  }

  Future<void> editGroup() async {
    final result = await Navigator.push<GroupModel>(
      context,
      MaterialPageRoute(
        builder: (_) => EditGroupPage(group: group),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        group = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        centerTitle: true,
      ),
      body: StreamBuilder<List<MemberModel>>(
  stream: firestoreService.getMembers(group.id),
  builder: (context, snapshot) {

    if (!snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final members = snapshot.data!;

    final me = members.firstWhere(
      (e) =>
          e.uid ==
          FirebaseAuth.instance.currentUser!.uid,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [

          StreakCard(
            days: me.streakDays,
          ),

          const SizedBox(height: 30),

          FailedButton(
            onPressed: () async {

              final confirm =
                  await showDialog<bool>(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title:
                        const Text("Reset Streak"),
                    content: const Text(
                      "Are you sure?\nYour streak will return to Day 0.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            false,
                          );
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            true,
                          );
                        },
                        child:
                            const Text("I Failed"),
                      ),
                    ],
                  );
                },
              );

              if (confirm != true) return;

              await firestoreService.resetMember(
                group.id,
                me.uid,
              );
            },
          ),

          const SizedBox(height: 40),

          LeaderboardCard(
            members: members,
          ),
        ],
      ),
    );
  },
),
    );
  }
}