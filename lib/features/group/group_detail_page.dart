import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/group_model.dart';
import '../../models/member_model.dart';
import '../../services/firestore_service.dart';

import '../../shared/widgets/failed_button.dart';
import '../../shared/widgets/leaderboard_card.dart';
import '../../shared/widgets/streak_card.dart';

import 'best_streak_page.dart';
import 'edit_group_page.dart';
import 'group_info_page.dart';


class GroupDetailPage extends StatefulWidget {
  final GroupModel group;

  const GroupDetailPage({
    super.key,
    required this.group,
  });

  @override
  State<GroupDetailPage> createState() =>
      _GroupDetailPageState();
}

class _GroupDetailPageState
    extends State<GroupDetailPage> {
  final FirestoreService firestoreService =
      FirestoreService();

  late GroupModel group;

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
            "Delete this group permanently?",
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                ),
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
    final result =
        await Navigator.push<GroupModel>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditGroupPage(group: group),
      ),
    );

    if (result == null) return;

    setState(() {
      group = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MemberModel>>(
      stream: firestoreService.getMembers(group.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        final members = snapshot.data!;

        final me = members.firstWhere(
          (e) =>
              e.uid ==
              FirebaseAuth.instance.currentUser!.uid,
        );

        final isOwner =
            me.role == "owner";

        return Scaffold(
          appBar: AppBar(
            title: Text(group.name),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) async {
                  switch (value) {
                    case "info":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GroupInfoPage(
                            group: group,
                          ),
                        ),
                      );
                      break;

                    case "best":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BestStreakPage(
                            groupId: group.id,
                          ),
                        ),
                      );
                      break;

                    case "edit":
                      editGroup();
                      break;

                    case "delete":
                      deleteGroup();
                      break;

                    case "leave":
                      final confirm =
                          await showDialog<bool>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text(
                              "Leave Group",
                            ),
                            content: const Text(
                              "Are you sure you want to leave this group?\n\nYou can join this group again later using the invite code.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    false,
                                  );
                                },
                                child: const Text(
                                  "Cancel",
                                ),
                              ),
                              ElevatedButton(
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    true,
                                  );
                                },
                                child: const Text(
                                  "Leave Group",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm != true) return;

                      await firestoreService
                          .leaveGroup(
                        group.id,
                        me.uid,
                      );

                      if (!mounted) return;

                      Navigator.pop(context);
                      break;
                  }
                },
                itemBuilder: (_) {
                  if (isOwner) {
                    return const [
                      PopupMenuItem(
                        value: "info",
                        child: Text("Group Info"),
                      ),
                      PopupMenuItem(
                        value: "best",
                        child: Text("Hall Of Fame"),
                      ),
                      PopupMenuItem(
                        value: "edit",
                        child: Text("Edit Group"),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Text("Delete Group"),
                      ),
                    ];
                  }

                  return const [
                    PopupMenuItem(
                      value: "info",
                      child: Text("Group Info"),
                    ),
                    PopupMenuItem(
                      value: "best",
                      child: Text("Best Streak"),
                    ),
                    PopupMenuItem(
                      value: "leave",
                      child: Text("Leave Group"),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.all(24),
            child: Column(
              children: [
                StreakCard(
                  days: me.streakDays,
                ),

                const SizedBox(height: 30),

                FailedButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text("I Failed"),
                          content: const Text(
                            "Reset your streak?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: const Text("Reset"),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm != true) return;

                    await firestoreService.createNotification(
                      groupId: group.id,
                      sender: me,
                    );

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
          ),
        );
      },
    );
  }
}