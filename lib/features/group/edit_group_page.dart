import 'package:flutter/material.dart';

import '../../models/group_model.dart';

class EditGroupPage extends StatefulWidget {
  final GroupModel group;

  const EditGroupPage({
    super.key,
    required this.group,
  });

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.group.name,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void saveGroup() {
    final updatedGroup = widget.group.copyWith(
      name: nameController.text.trim(),
    );

    Navigator.pop(context, updatedGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Group Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveGroup,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}