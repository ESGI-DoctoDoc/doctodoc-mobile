import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class OnboardingGeneralPractitionerStep extends StatefulWidget {
  final void Function(String generalPractitioner) onFinished;
  final void Function() onSkip;

  const OnboardingGeneralPractitionerStep({
    super.key,
    required this.onFinished,
    required this.onSkip,
  });

  @override
  State<OnboardingGeneralPractitionerStep> createState() =>
      _OnboardingGeneralPractitionerStepState();
}

class _OnboardingGeneralPractitionerStepState extends State<OnboardingGeneralPractitionerStep> {
  final TextEditingController generalPractitionerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.onSkip();
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
              "Quel est votre médecin traitant ?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Si vous n'en avez pas, laissez ce champ vide."),
            PrimaryButton(
              label: "Sélectionner un médecin traitant",
              onTap: () {
                widget.onFinished('00000000-0000-0000-0000-000000000001');
              },
            )
          ],
        ),
      ),
    );
  }
}
