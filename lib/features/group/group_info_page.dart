import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/group_model.dart';
import '../../models/member_model.dart';
import '../../services/firestore_service.dart';

class GroupInfoPage extends StatefulWidget {
  final GroupModel group;

  const GroupInfoPage({
    super.key,
    required this.group,
  });

  @override
  State<GroupInfoPage> createState() =>
      _GroupInfoPageState();
}

class _GroupInfoPageState
    extends State<GroupInfoPage> {
  final FirestoreService firestoreService =
      FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<MemberModel>>(
        future: firestoreService.getMembersList(
          widget.group.id,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final members = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Icon(
                Icons.groups,
                size: 90,
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  widget.group.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.qr_code),
                  title:
                      const Text("Invite Code"),
                  subtitle:
                      Text(widget.group.code),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.copy,
                    ),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: widget.group.code,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Members (${members.length})",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              ...members.map(
                (member) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        member.username[0]
                            .toUpperCase(),
                      ),
                    ),
                    title: Text(
                      member.username,
                    ),
                    subtitle: Text(
                      member.role ==
                              "owner"
                          ? "Owner"
                          : "Member",
                    ),
                    trailing:
                        member.role == "owner"
                            ? const Icon(
                                Icons.workspace_premium,
                                color:
                                    Colors.amber,
                              )
                            : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}