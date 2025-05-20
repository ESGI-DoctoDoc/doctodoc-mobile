import 'package:doctodoc_mobile/blocs/appointment_flow_bloc/appointment_flow_bloc.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/appointment_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/inputs/medical_concern_selection.dart';
import '../widgets/onboarding_loading.dart';

class AppointmentStepMedicalConcern extends StatefulWidget {
  final String doctorId;
  final GlobalKey<FormState> formKey;
  final Function(String) onNext;

  const AppointmentStepMedicalConcern({
    super.key,
    required this.doctorId,
    required this.formKey,
    required this.onNext,
  });

  @override
  State<AppointmentStepMedicalConcern> createState() => _AppointmentStepMedicalConcernState();
}

class _AppointmentStepMedicalConcernState extends State<AppointmentStepMedicalConcern> {
  final TextEditingController _medicalConcernController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMedicalConcerns();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentFlowBloc, AppointmentFlowState>(
      builder: (context, state) {
        return switch (state.getMedicalConcernsStatus) {
          GetMedicalConcernsStatus.initial ||
          GetMedicalConcernsStatus.loading =>
            const OnboardingLoading(),
          GetMedicalConcernsStatus.success => _buildSuccess(state.medicalConcerns),
          GetMedicalConcernsStatus.error => _buildError(),
        };
      },
    );
  }

  Widget _buildSuccess(List<MedicalConcern> medicalConcerns) {
    List<MedicalConcernItem> medicalConcernItems = medicalConcerns
        .map((medicalConcern) =>
            MedicalConcernItem(medicalConcernId: medicalConcern.id, name: medicalConcern.name))
        .toList();

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
                medicalConcerns: medicalConcernItems,
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

  void _fetchMedicalConcerns() {
    final appointmentFlowBloc = context.read<AppointmentFlowBloc>();
    appointmentFlowBloc.add(GetMedicalConcerns(doctorId: widget.doctorId));
  }
}
