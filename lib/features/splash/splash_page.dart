import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../auth/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.groups,
              size: 90,
              color: Colors.white,
            ),

            const SizedBox(height: 25),

            const Text(
              "Group Trackers",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Track anything with your friends",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}