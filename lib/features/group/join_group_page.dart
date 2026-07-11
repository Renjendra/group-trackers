import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/group_model.dart';
import '../../models/member_model.dart';
import '../../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinGroupPage extends StatefulWidget {
  const JoinGroupPage({super.key});

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final TextEditingController codeController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  GroupModel? foundGroup;
  MemberModel? owner;

  bool isSearching = false;
  bool isJoining = false;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future<void> searchGroup() async {
    final code = codeController.text.trim();

    if (code.isEmpty) return;

    setState(() {
      isSearching = true;
      foundGroup = null;
      owner = null;
    });

    final group =
        await firestoreService.findGroupByCode(code);

    if (group != null) {
      final groupOwner =
          await firestoreService.getOwner(group);

      setState(() {
        foundGroup = group;
        owner = groupOwner;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Group not found."),
        ),
      );
    }

    setState(() {
      isSearching = false;
    });
  }

  Future<void> acceptInvite() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  if (foundGroup == null) return;

  setState(() {
    isJoining = true;
  });

  final currentUser =
      await firestoreService.getUser(user.uid);

  if (currentUser == null) {
    setState(() {
      isJoining = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("User data not found."),
      ),
    );

    return;
  }

  final member = MemberModel(
  uid: user.uid,
  username: currentUser.username,
  role: "member",
  joinedAt: Timestamp.now(),
  lastResetAt: Timestamp.now(),
);

  await firestoreService.joinGroup(
    foundGroup!,
    member,
  );

  if (!mounted) return;

  Navigator.pop(context, true);
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
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: "Invite Code",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed:
                    isSearching ? null : searchGroup,
                child: isSearching
                    ? const CircularProgressIndicator()
                    : const Text("Search"),
              ),
            ),

            const SizedBox(height: 30),

            if (foundGroup != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.groups,
                        size: 70,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        foundGroup!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Owner: ${owner?.username ?? "-"}",
                      ),

                      Text(
                        "Members: ${foundGroup!.members}",
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "Everyone in this group can see your streak.",
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isJoining
                              ? null
                              : acceptInvite,
                          child: isJoining
                              ? const CircularProgressIndicator()
                              : const Text("Accept Invite"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}