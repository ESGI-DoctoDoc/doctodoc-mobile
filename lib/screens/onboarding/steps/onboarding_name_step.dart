import 'package:doctodoc_mobile/shared/widgets/inputs/firstname_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/lastname_input.dart';
import 'package:flutter/material.dart';

class OnboardingNameStep extends StatefulWidget {
  const OnboardingNameStep({super.key});

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
    firstnameController.addListener(_onNameChanged);
    lastnameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    if (_nameKey.currentState?.validate() ?? false) {
      _onNext();
    }
  }

  void _onNext() {
    final firstName = firstnameController.text.trim();
    final lastName = lastnameController.text.trim();
    print("onNext() called with: $firstName $lastName");
  }

  @override
  void dispose() {
    firstnameController.removeListener(_onNameChanged);
    lastnameController.removeListener(_onNameChanged);
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
            Text("Entrez votre nom et prénom"),
            const SizedBox(height: 20),
            FirstnameInput(controller: firstnameController),
            const SizedBox(height: 10),
            LastnameInput(controller: lastnameController),
          ],
        ),
      ),
    );
  }
}
