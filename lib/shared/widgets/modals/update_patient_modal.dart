import 'package:doctodoc_mobile/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../buttons/primary_button.dart';
import '../inputs/firstname_input.dart';
import '../inputs/lastname_input.dart';
import 'base/modal_base.dart';

Future<Patient?> showUpdatePatientModal(
  BuildContext context,
  Patient patient,
) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Modifier le patient",
          child: _UpdatePatientWidget(patient: patient),
        ),
      ];
    },
  );
}

class _UpdatePatientWidget extends StatefulWidget {
  final Patient patient;

  const _UpdatePatientWidget({required this.patient});

  @override
  State<_UpdatePatientWidget> createState() => _UpdatePatientWidgetState();
}

class _UpdatePatientWidgetState extends State<_UpdatePatientWidget> {
  final GlobalKey<FormState> updatePatientKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.patient.firstName;
    lastNameController.text = widget.patient.lastName;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: updatePatientKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                FirstnameInput(controller: firstNameController),
                const SizedBox(height: 10),
                LastnameInput(controller: lastNameController),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: "Mettre à jour les informations",
                  onTap: () => _updatePatient(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updatePatient() {
    if (updatePatientKey.currentState!.validate()) {
      // final updatedPatient = Patient(
      //   id: widget.patient.id,
      //   firstName: firstNameController.text,
      //   lastName: lastNameController.text,
      // );
      Navigator.of(context).pop(/*updatedPatient*/);
    }
  }
}
