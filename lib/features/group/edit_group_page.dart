import 'package:flutter/material.dart';

import '../../models/group_model.dart';
import '../../services/firestore_service.dart';

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

  final FirestoreService firestoreService = FirestoreService();

  bool isLoading = false;

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

  Future<void> saveGroup() async {
    if (nameController.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
    });

    final updatedGroup = widget.group.copyWith(
      name: nameController.text.trim(),
    );

    await firestoreService.updateGroup(updatedGroup);

    if (!mounted) return;

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
                onPressed: isLoading ? null : saveGroup,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}