import 'package:flutter/material.dart';

import '../../models/group_model.dart';

import '../../core/utils/code_generator.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController groupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Group Name",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: groupController,
              decoration: const InputDecoration(
                hintText: "Example: My Friends",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                   if (groupController.text.trim().isEmpty) {
                    return;
                  }
                  final group = GroupModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: groupController.text.trim(),
                    code: CodeGenerator.generateCode(),
                    members: 1,
                  );

                  Navigator.pop(
                    context,
                    group,
                  );
                },
                child: const Text("Create Group"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}