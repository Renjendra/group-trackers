import 'package:flutter/material.dart';

import '../../models/member_model.dart';
import '../../services/firestore_service.dart';

class BestStreakPage extends StatelessWidget {
  final String groupId;

  const BestStreakPage({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hall Of Fame"),
      ),
      body: StreamBuilder<List<MemberModel>>(
        stream: FirestoreService().getMembers(groupId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final members = snapshot.data!
              .where(
                (e) => e.bestStreak >= 15,
              )
              .toList();

          members.sort(
            (a, b) =>
                b.bestStreak.compareTo(a.bestStreak),
          );

          if (members.isEmpty) {
            return const Center(
              child: Text(
                "No Hall Of Fame Yet",
              ),
            );
          }

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (_, index) {
              final member = members[index];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    "${index + 1}",
                  ),
                ),
                title: Text(member.username),
                trailing: Text(
                  "🔥 ${member.bestStreak}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}