import 'package:doctodoc_mobile/blocs/appointment_blocs/appointment_flow_bloc/appointment_flow_bloc.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/appointment_label.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/appointment/care_tracking_for_appointment.dart';
import '../../../shared/widgets/inputs/care_tracking_selection.dart';

class AppointmentStepCareTracking extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(String) onNext;
  final VoidCallback? onEmpty;
  final String patientId;

  const AppointmentStepCareTracking({
    super.key,
    required this.formKey,
    required this.onNext,
    required this.patientId,
    this.onEmpty,
  });

  @override
  State<AppointmentStepCareTracking> createState() => _AppointmentStepCareTrackingState();
}

class _AppointmentStepCareTrackingState extends State<AppointmentStepCareTracking> {
  final TextEditingController _careTrackingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AppointmentFlowBloc>().add(GetCareTrackings(patientId: widget.patientId));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const AppointmentLabel(
                label: "Souhaitez-vous lier ce rendez-vous avec votre suivi de dossier ?",
              ),
              const SizedBox(height: 10),
              BlocBuilder<AppointmentFlowBloc, AppointmentFlowState>(
                builder: (context, state) {
                  return switch (state.getCareTrackingsStatus) {
                    GetCareTrackingsStatus.initial ||
                    GetCareTrackingsStatus.loading =>
                      const OnboardingLoading(),
                    GetCareTrackingsStatus.success => _buildSuccess(state.careTrackings),
                    GetCareTrackingsStatus.error => _buildError(),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess(List<CareTrackingForAppointment> careTrackings) {
    if (careTrackings.isEmpty) {
      return const Text(
        "Aucun suivi de dossier n'est disponible pour le moment.",
      );
    }
    final List<CareTrackingItem> careTrackingItems = [
      const CareTrackingItem(
        careTrackingId: '',
        careTrackingName: 'Ne pas lier',
      ),
      ...careTrackings.map(
        (careTracking) => CareTrackingItem(
          careTrackingId: careTracking.id,
          careTrackingName: careTracking.name,
        ),
      ),
    ];

    return CareTrackingSelection(
      controller: _careTrackingController,
      careTrackings: careTrackingItems,
      required: false,
      onChange: (item) {
        widget.onNext(item.value);
      },
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }
}
