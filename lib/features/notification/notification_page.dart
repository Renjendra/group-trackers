import 'package:flutter/material.dart';

import '../../models/notification_model.dart';
import '../../services/firestore_service.dart';
import 'notification_tile.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final FirestoreService firestoreService =
      FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: firestoreService.getNotifications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final notifications = snapshot.data!;

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
                notification: notifications[index],
              );
            },
          );
        },
      ),
    );
  }
}