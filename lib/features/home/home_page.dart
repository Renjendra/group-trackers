import 'package:flutter/material.dart';

import '../group/create_group_page.dart';

import '../../models/group_model.dart';

import '../../services/group_service.dart';

import '../group/group_detail_page.dart';

import '../group/join_group_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GroupService groupService = GroupService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Trackers"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: groupService.groups.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.groups_outlined,
                              size: 100,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              "No Groups Yet",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Create your first group\nto start tracking together.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount:groupService.groups.length,
                        itemBuilder: (context, index) {
                        final group = groupService.groups[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GroupDetailPage(group: group),
                                ),
                              );

                              if (!mounted) return;

                              setState(() {});
                            },
                            leading: const Icon(Icons.groups),
                            title: Text(group.name),
                            subtitle: Text(
                              "Code: ${group.code}\nMembers: ${group.members}",
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          );
                        },
                      ),
              ),

              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateGroupPage(),
                          ),
                        );

                        if (result is GroupModel) {
                          setState(() {
                            groupService.addGroup(result);
                          });
                        }
                      },
                      child: const Text("Create Group"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JoinGroupPage(),
                        ),
                      );

                      if (result == true) {
                        setState(() {});
                      }
                    },
                    child: const Text("Join Group"),
                  ),
                ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}