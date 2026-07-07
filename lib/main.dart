import 'package:flutter/material.dart';
import 'features/splash/splash_page.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const GroupTrackersApp());
}

class GroupTrackersApp extends StatelessWidget {
  const GroupTrackersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group Trackers',
      theme: AppTheme.darkTheme,
      home: const SplashPage(),
    );
  }
}