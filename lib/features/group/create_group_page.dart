import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/utils/code_generator.dart';
import '../../models/group_model.dart';
import '../../services/firestore_service.dart';
import '../../models/member_model.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController groupController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  bool isLoading = false;

  Future<void> createGroup() async {
  if (groupController.text.trim().isEmpty) return;

  setState(() {
    isLoading = true;
  });

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    setState(() {
      isLoading = false;
    });
    return;
  }

  final currentUser =
      await firestoreService.getUser(user.uid);

  if (currentUser == null) {
    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("User data not found."),
      ),
    );

    return;
  }

  final group = GroupModel(
    id: FirebaseFirestore.instance.collection('groups').doc().id,
    name: groupController.text.trim(),
    code: CodeGenerator.generateCode(),
    ownerId: user.uid,
    members: 1,
    createdAt: Timestamp.now(),
  );

  final owner = MemberModel(
  uid: user.uid,
  username: currentUser.username,
  role: "owner",
  joinedAt: Timestamp.now(),
  lastResetAt: Timestamp.now(),
);

  await firestoreService.createGroup(
    group,
    owner,
  );

  if (!mounted) return;

  Navigator.pop(context);
}

  @override
  void dispose() {
    groupController.dispose();
    super.dispose();
  }

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
                hintText: "Example: Family",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : createGroup,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Create Group"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}