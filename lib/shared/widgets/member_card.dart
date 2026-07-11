import 'package:flutter/material.dart';

import '../../models/member_model.dart';

class MemberCard extends StatelessWidget {
  final List<MemberModel> members;

  const MemberCard({
    super.key,
    required this.members,
  });

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
                "Members",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            ...members.map(
              (member) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Text(
                    member.username[0].toUpperCase(),
                  ),
                ),
                title: Text(member.username),
                subtitle: Text(member.role),
                trailing: Text(
                  "🔥 ${member.streakDays}",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}