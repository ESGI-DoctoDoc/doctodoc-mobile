import 'package:doctodoc_mobile/shared/widgets/inputs/email_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/firstname_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/lastname_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/phone_input.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../banners/info_banner.dart';
import '../buttons/primary_button.dart';

class CreatePatientModal extends StatefulWidget {
  const CreatePatientModal({super.key});

  @override
  State<CreatePatientModal> createState() => _CreatePatientModalState();
}

class _CreatePatientModalState extends State<CreatePatientModal> {
  final forgotPasswordKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isSubmitted = false;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Column(
            children: [
              ..._buildOnSubmitted(),
              Form(
                key: forgotPasswordKey,
                child: Column(
                  children: [
                    FirstnameInput(controller: firstNameController),
                    const SizedBox(height: 10),
                    LastnameInput(controller: lastNameController),
                    const SizedBox(height: 10),
                    EmailInput(controller: emailController),
                    const SizedBox(height: 10),
                    PhoneInput(controller: phoneController),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: "Créer le patient",
                disabled: isSubmitted,
                onTap: () => _createPatient(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOnSubmitted() {
    if (isSubmitted) {
      return [
        const InfoBanner(
          title: "Le patient a bien été créé",
        ),
        const SizedBox(height: 20),
      ];
    } else {
      return [const SizedBox.shrink()];
    }
  }

  void _createPatient() async {
    if (forgotPasswordKey.currentState?.validate() == false) {
      return;
    }
    print("Patient created: ${firstNameController.text} ${lastNameController.text}");
    //todo appel create patient
    setState(() {
      isSubmitted = true;
    });
    // Simulate returning patient after creation
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pop(Patient(firstNameController.text, lastNameController.text, "mockedId"));
    });
  }
}

Future<Patient?> showCreatePatientModal(BuildContext context) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasSabGradient: false,
          hasTopBarLayer: false,
          pageTitle: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Créer un patient",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isTopBarLayerAlwaysVisible: true,
          trailingNavBarWidget: IconButton(
            padding: const EdgeInsets.all(20),
            icon: const Icon(Icons.close),
            onPressed: Navigator.of(context).pop,
          ),
          child: const CreatePatientModal(),
        ),
      ];
    },
  );
}

//todo remove this class and create the real one
class Patient {
  final String firstName;
  final String lastName;
  final String id;

  Patient(this.firstName, this.lastName, this.id);
}
