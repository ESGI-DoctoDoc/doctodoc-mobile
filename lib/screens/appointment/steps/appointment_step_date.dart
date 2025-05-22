import 'package:doctodoc_mobile/models/appointment/medical_concern_appointment_availability.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/select_day_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/appointment_flow_bloc/appointment_flow_bloc.dart';
import '../../../shared/widgets/inputs/select_hour_input.dart';
import '../widgets/appointment_label.dart';

class AppointmentStepDate extends StatefulWidget {
  final String medicalConcernId;
  final GlobalKey<FormState> formKey;

  const AppointmentStepDate({
    super.key,
    required this.medicalConcernId,
    required this.formKey,
  });

  @override
  State<AppointmentStepDate> createState() => _AppointmentStepDateState();
}

class _AppointmentStepDateState extends State<AppointmentStepDate> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAppointmentsAvailability();
    // _dateController.addListener(_fetchAppointmentsAvailability);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentFlowBloc, AppointmentFlowState>(
      builder: (context, state) {
        return switch (state.getAppointmentAvailabilityStatus) {
          GetAppointmentAvailabilityStatus.initial ||
          GetAppointmentAvailabilityStatus.loading =>
            const OnboardingLoading(),
          GetAppointmentAvailabilityStatus.success => _buildSuccess(state.appointmentAvailability),
          GetAppointmentAvailabilityStatus.error => _buildError(),
        };
      },
    );
  }

  Widget _buildSuccess(List<MedicalConcernAppointmentAvailability> appointmentsAvailability) {
    List<SelectHourItem> hours = appointmentsAvailability
        .map((appointmentAvailability) => SelectHourItem(
              slotId: appointmentAvailability.start,
              startTime: appointmentAvailability.start,
              isBooked: appointmentAvailability.isBooked,
            ))
        .toList();

    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const AppointmentLabel(label: "Choisir la date"),
              SelectDayInput(controller: _dateController),
              const AppointmentLabel(label: "Choisissez un horaire"),
              // todo : Corentin
              SelectHourInput(
                controller: _hourController,
                slots: hours,
              ),
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

  void _fetchAppointmentsAvailability() {
    // todo put the loading
    print(_dateController.text.replaceAll('/', '-'));
    const date = "2025-05-19"; // todo format

    final appointmentFlowBloc = context.read<AppointmentFlowBloc>();
    appointmentFlowBloc.add(GetAppointmentsAvailability(
      medicalConcernId: widget.medicalConcernId,
      date: date,
    ));
  }
}
