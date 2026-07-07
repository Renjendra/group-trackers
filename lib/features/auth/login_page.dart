import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              const Text(
                "Welcome Back ",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Login to continue tracking with your friends.",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                decoration: InputDecoration(
                  hintText: "Username",
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Don't have an account? Register",
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}