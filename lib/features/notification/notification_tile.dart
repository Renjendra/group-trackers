import 'package:flutter/material.dart';

import '../../models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(
            Icons.local_fire_department,
            color: Colors.white,
          ),
        ),
        title: Text(
          notification.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "lost a ${notification.streak} day streak",
        ),
        trailing: Text(
          "${notification.createdAt.toDate().day}/${notification.createdAt.toDate().month}",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}