import 'package:flutter/material.dart';

class OnboardingLoading extends StatelessWidget {
  const OnboardingLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Chargement..."),
        ],
      ),
    );
  }
}
