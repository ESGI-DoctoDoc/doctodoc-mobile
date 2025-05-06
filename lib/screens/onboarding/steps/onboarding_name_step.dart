import 'package:doctodoc_mobile/shared/widgets/inputs/firstname_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/lastname_input.dart';
import 'package:flutter/material.dart';

class OnboardingNameStep extends StatefulWidget {
  final void Function(bool isValid, String firstName, String lastName) onNext;

  const OnboardingNameStep({
    super.key,
    required this.onNext,
  });

  @override
  State<OnboardingNameStep> createState() => _OnboardingNameStepState();
}

class _OnboardingNameStepState extends State<OnboardingNameStep> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _handleChange() {
    final firstName = firstnameController.text.trim();
    final lastName = lastnameController.text.trim();
    widget.onNext(_nameKey.currentState?.validate() ?? false, firstName, lastName);
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _nameKey,
        child: Column(
          children: [
            const Text("Entrez votre nom et prénom"),
            const SizedBox(height: 20),
            FirstnameInput(controller: firstnameController, onChanged: () => _handleChange()),
            const SizedBox(height: 10),
            LastnameInput(controller: lastnameController, onChanged: () => _handleChange()),
          ],
        ),
      ),
    );
  }
}
