import 'package:flutter/material.dart';

class OnboardingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int step;

  const OnboardingAppBar({
    super.key,
    required this.title,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    const numberOfPages = 5;
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Vérification du compte"),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: step / numberOfPages,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
