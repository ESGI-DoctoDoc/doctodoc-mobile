import 'package:doctodoc_mobile/shared/widgets/inputs/gender_input.dart';
import 'package:flutter/material.dart';

class OnboardingGenderStep extends StatefulWidget {
  final void Function(bool, String) onNext;

  const OnboardingGenderStep({
    super.key,
    required this.onNext,
  });

  @override
  State<OnboardingGenderStep> createState() => _OnboardingGenderStepState();
}

class _OnboardingGenderStepState extends State<OnboardingGenderStep> {
  final TextEditingController genderController = TextEditingController();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _handleChange() {
    final gender = genderController.text.trim();
    widget.onNext(_nameKey.currentState?.validate() ?? false, gender);
  }

  @override
  void dispose() {
    genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _nameKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quel est votre genre ?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            GenderInput(
              controller: genderController,
              onChange: (gender) {
                _handleChange();
              },
            ),
          ],
        ),
      ),
    );
  }
}
