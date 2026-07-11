import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  final int days;

  const StreakCard({
    super.key,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 24,
        ),
        child: Column(
          children: [
            const Text(
              "🔥",
              style: TextStyle(fontSize: 60),
            ),

            const SizedBox(height: 20),

            Text(
              "$days",
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              "DAYS",
              style: TextStyle(
                fontSize: 24,
                letterSpacing: 4,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              days == 0
                  ? "Start your streak today."
                  : "Keep Going 💪",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}