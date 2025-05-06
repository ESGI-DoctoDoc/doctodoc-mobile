import 'package:flutter/material.dart';

import '../../auth/otp_screen.dart';

class OtpOnboardingScreen extends StatefulWidget {
  const OtpOnboardingScreen({super.key});

  @override
  State<OtpOnboardingScreen> createState() => _OtpOnboardingScreenState();
}

class _OtpOnboardingScreenState extends State<OtpOnboardingScreen> {
  bool isCodeSent = false;

  void _sendCode() {
    print("Code envoyé via onboarding !");
    setState(() => isCodeSent = true);
  }

  void _submitCode() {
    print("Code validé dans l'onboarding !");
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Bienvenue !"),
            SizedBox(height: 20),
            OtpWidget()
          ],
        ),
      ),
    );
  }
}