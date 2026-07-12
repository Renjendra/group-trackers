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
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.notifications),
      ),
      title: Text(
        "${notification.username} failed after ${notification.streak} days",
      ),
      subtitle: Text(
        notification.createdAt
            .toDate()
            .toString()
            .substring(0, 16),
      ),
    );
  }
}