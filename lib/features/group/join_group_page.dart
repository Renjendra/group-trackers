import 'package:flutter/material.dart';

import '../../models/group_model.dart';
import '../../services/group_service.dart';

class JoinGroupPage extends StatefulWidget {
  const JoinGroupPage({super.key});

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final TextEditingController codeController = TextEditingController();

  final GroupService groupService = GroupService();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  void joinGroup() {
    final code = codeController.text.trim().toUpperCase();

    try {
      final group = groupService.groups.firstWhere(
        (g) => g.code.toUpperCase() == code,
      );

      final updatedGroup = group.copyWith(
        members: group.members + 1,
      );

      groupService.updateGroup(updatedGroup);

      Navigator.pop(context, true);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invite code not found."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: "Invite Code",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: joinGroup,
                child: const Text("Join Group"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}