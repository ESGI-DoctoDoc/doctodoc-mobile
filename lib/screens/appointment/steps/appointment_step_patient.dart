import 'package:doctodoc_mobile/screens/appointment/widgets/appointment_label.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/create_patient_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/inputs/patient_selection.dart';
import '../widgets/onboarding_loading.dart';

class AppointmentStepPatient extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(PatientItem) onNext;

  const AppointmentStepPatient({
    super.key,
    required this.formKey,
    required this.onNext,
  });

  @override
  State<AppointmentStepPatient> createState() => _AppointmentStepPatientState();
}

class _AppointmentStepPatientState extends State<AppointmentStepPatient> {
  final TextEditingController _patientController = TextEditingController();
  List<PatientItem> patients = [
    PatientItem(
      patientId: "patientId1",
      firstname: "Corentin",
      lastname: "Lechene",
    ),
    PatientItem(
      patientId: "patientId2",
      firstname: "Bernard",
      lastname: "Lechene",
    ),
  ];

  //todo mélissa
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _patientController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const OnboardingLoading();
    } else if (_hasError) {
      return _buildError();
    } else {
      return _buildSuccess();
    }
  }

  Widget _buildSuccess() {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              AppointmentLabel(
                label: "Selectionner le patient",
                onTap: () async {
                  final patient = await showCreatePatientModal(context);
                  if (patient != null) {
                    final newPatient = PatientItem(
                      patientId: patient.id,
                      firstname: patient.firstName,
                      lastname: patient.lastName,
                    );

                    setState(() {
                      patients.add(newPatient);
                    });
                  }
                },
              ),
              PatientSelection(
                controller: _patientController,
                patients: patients,
                onChange: (patient) {
                  widget.onNext(patient);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }
}
