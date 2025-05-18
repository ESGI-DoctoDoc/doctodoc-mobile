import 'package:doctodoc_mobile/screens/appointment/widgets/appointment_label.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/inputs/medical_concern_selection.dart';
import '../widgets/onboarding_loading.dart';

class AppointmentStepMedicalConcern extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(String) onNext;

  const AppointmentStepMedicalConcern({
    super.key,
    required this.formKey,
    required this.onNext,
  });

  @override
  State<AppointmentStepMedicalConcern> createState() => _AppointmentStepMedicalConcernState();
}

class _AppointmentStepMedicalConcernState extends State<AppointmentStepMedicalConcern> {
  final TextEditingController _medicalConcernController = TextEditingController();

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

  Widget _buildSuccess() {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const AppointmentLabel(label: "Sélectionner le motif de consultation"),
              MedicalConcernSelection(
                controller: _medicalConcernController,
                medicalConcerns: const [
                  MedicalConcernItem(
                    medicalConcernId: "medicalConcernId1",
                    name: "Consultation de routine",
                  ),
                  MedicalConcernItem(
                    medicalConcernId: "medicalConcernId2",
                    name: "Suivi de traitement",
                  ),
                  MedicalConcernItem(
                    medicalConcernId: "medicalConcernId3",
                    name: "Urgence médicale",
                  ),
                ],
                onChange: (item) {
                  print("Selected medical concern: ${item.label}");
                  widget.onNext(item.value);
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
}
