import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/notification_model.dart';
import '../../services/firestore_service.dart';

import 'notification_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() =>
      _NotificationPageState();
}

class _NotificationPageState
    extends State<NotificationPage> {
  final FirestoreService firestoreService =
      FirestoreService();

  final currentUser =
      FirebaseAuth.instance.currentUser!;

  bool _alreadyMarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: firestoreService.getNotifications(
          currentUser.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final notifications =
              snapshot.data ?? [];

          if (!_alreadyMarked &&
              notifications.isNotEmpty) {
            _alreadyMarked = true;

            WidgetsBinding.instance
                .addPostFrameCallback((_) async {
              await firestoreService
                  .markAllNotificationsAsRead(
                currentUser.uid,
              );
            });
          }

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                "No notifications",
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationTile(
                notification:
                    notifications[index],
              );
            },
          );
        },
      ),
    );
  }
}