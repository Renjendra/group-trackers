import 'package:flutter/material.dart';

import '../../models/group_model.dart';
import '../../services/firestore_service.dart';

import 'edit_group_page.dart';

class GroupDetailPage extends StatefulWidget {
  final GroupModel group;

  const GroupDetailPage({
    super.key,
    required this.group,
  });

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  late GroupModel group;

  final FirestoreService firestoreService = FirestoreService();

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
            "Are you sure you want to delete this group?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
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
    final result = await Navigator.push<GroupModel>(
      context,
      MaterialPageRoute(
        builder: (_) => EditGroupPage(group: group),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        group = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text("Invite Code"),
              subtitle: Text(group.code),
            ),

            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Members"),
              subtitle: Text(group.members.toString()),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: editGroup,
                child: const Text("Edit Group"),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: deleteGroup,
                child: const Text(
                  "Delete Group",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}