import 'package:flutter/material.dart';

class OnboardingGeneralPractitionerStep extends StatefulWidget {
  const OnboardingGeneralPractitionerStep({super.key});

  @override
  State<OnboardingGeneralPractitionerStep> createState() => _OnboardingGeneralPractitionerStepState();
}

class _OnboardingGeneralPractitionerStepState extends State<OnboardingGeneralPractitionerStep> {
  final TextEditingController generalPractitionerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        child: Column(
          children: [
            Text("Sélectionnez votre médecin traitant"),
            const SizedBox(height: 20),
            //todo add doctor list
          ],
        ),
      ),
    );
  }
}
