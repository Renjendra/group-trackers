import 'package:flutter/material.dart';

import '../../models/member_model.dart';

class LeaderboardCard extends StatelessWidget {
  final List<MemberModel> members;

  const LeaderboardCard({
    super.key,
    required this.members,
  });

  String getRank(int index) {
    switch (index) {
      case 0:
        return "🥇";
      case 1:
        return "🥈";
      case 2:
        return "🥉";
      default:
        return "#${index + 1}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Leaderboard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ...List.generate(
              members.length,
              (index) {
                final member = members[index];

                return ListTile(
                  leading: Text(
                    getRank(index),
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(member.username),
                  trailing: Text(
                    "🔥 ${member.streakDays}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}