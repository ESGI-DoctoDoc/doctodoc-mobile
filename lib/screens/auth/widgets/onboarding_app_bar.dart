import 'package:flutter/material.dart';

class OnboardingAppBar extends StatelessWidget {
  const OnboardingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Vérification du compte"),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
