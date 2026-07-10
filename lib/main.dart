import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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