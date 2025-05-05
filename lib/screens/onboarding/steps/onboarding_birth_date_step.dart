import 'package:doctodoc_mobile/shared/widgets/inputs/birthdate_input.dart';
import 'package:flutter/material.dart';

class OnboardingBirthDateStep extends StatefulWidget {
  const OnboardingBirthDateStep({
    super.key,
  });

  @override
  State<OnboardingBirthDateStep> createState() => _OnboardingBirthDateStepState();
}

class _OnboardingBirthDateStepState extends State<OnboardingBirthDateStep> {
  final TextEditingController birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        child: Column(
          children: [
            Text("Entrez votre date de naissance"),
            const SizedBox(height: 20),
            BirthdateInput(controller: birthDateController),
          ],
        ),
      ),
    );
  }
}
