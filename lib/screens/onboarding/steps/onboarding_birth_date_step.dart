import 'package:doctodoc_mobile/shared/widgets/inputs/birthdate_input.dart';
import 'package:flutter/material.dart';

class OnboardingBirthDateStep extends StatefulWidget {
  final void Function(bool isValid, String birthDate) onNext;

  const OnboardingBirthDateStep({
    super.key,
    required this.onNext,
  });

  @override
  State<OnboardingBirthDateStep> createState() =>
      _OnboardingBirthDateStepState();
}

class _OnboardingBirthDateStepState extends State<OnboardingBirthDateStep> {
  final TextEditingController birthDateController = TextEditingController();

  void _handleNext() {
    final birthDate = birthDateController.text.trim();
    final isValid = birthDate.isNotEmpty;
    widget.onNext(isValid, birthDate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quel est votre date de naissance ?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            BirthdateInput(
              controller: birthDateController,
              onChanged: () => _handleNext(),
            ),
          ],
        ),
      ),
    );
  }
}
