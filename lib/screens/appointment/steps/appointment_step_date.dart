import 'package:doctodoc_mobile/models/appointment/medical_concern_appointment_availability.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/select_day_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../../blocs/appointment_blocs/appointment_flow_bloc/appointment_flow_bloc.dart';
import '../../../shared/widgets/inputs/select_hour_input.dart';
import '../types/appointment_flow_slot_data.dart';
import '../widgets/appointment_label.dart';

class AppointmentStepDate extends StatefulWidget {
  final String? medicalConcernId;
  final GlobalKey<FormState> formKey;
  final Function(AppointmentFlowSlotData) onNext;

  const AppointmentStepDate({
    super.key,
    required this.formKey,
    required this.onNext,
    this.medicalConcernId,
  });

  @override
  State<AppointmentStepDate> createState() => _AppointmentStepDateState();
}

class _AppointmentStepDateState extends State<AppointmentStepDate> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  String slotId = '';

  @override
  void initState() {
    super.initState();
    Jiffy.setLocale('fr-FR');
    _dateController.text = Jiffy.now().format(pattern: 'yyyy-MM-dd');
    _fetchAppointmentsAvailability();

    _dateController.addListener(_fetchAppointmentsAvailability);
    _hourController.addListener(() {
      if (_hourController.text.isNotEmpty) {
        widget.onNext(AppointmentFlowSlotData(
          slotId: slotId,
          time: _hourController.text,
          date: _dateController.text,
        ));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.removeListener(_fetchAppointmentsAvailability);
    _dateController.dispose();
    _hourController.dispose();
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
              const AppointmentLabel(label: "Choisir la date"),
              SelectDayInput(controller: _dateController),
              const AppointmentLabel(label: "Choisissez un horaire"),
              BlocBuilder<AppointmentFlowBloc, AppointmentFlowState>(
                builder: (context, state) {
                  return switch (state.getAppointmentAvailabilityStatus) {
                    GetAppointmentAvailabilityStatus.initial ||
                    GetAppointmentAvailabilityStatus.loading =>
                      const OnboardingLoading(),
                    GetAppointmentAvailabilityStatus.success =>
                      _buildSuccess(state.appointmentAvailability),
                    GetAppointmentAvailabilityStatus.error => _buildError(),
                  };
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess(MedicalConcernAppointmentAvailability? appointmentsAvailability) {
    if (appointmentsAvailability == null) {
      return _buildError();
    } else {
      slotId = appointmentsAvailability.today.isNotEmpty
          ? appointmentsAvailability.today.first.slotId
          : '';
      List<SelectHourItem> hours = appointmentsAvailability.today
          .map((appointmentAvailability) => SelectHourItem(
                slotId: appointmentAvailability.start,
                startTime: appointmentAvailability.start,
                isBooked: appointmentAvailability.isBooked,
              ))
          .toList();

      if (hours.isEmpty) {
        final String? previousDate = appointmentsAvailability.previous;
        final String? nextDate = appointmentsAvailability.next;

        String availableDatesMessage;

        if (previousDate != null &&
            previousDate.isNotEmpty &&
            nextDate != null &&
            nextDate.isNotEmpty) {
          final formattedPrev =
              Jiffy.parse(previousDate, pattern: 'yyyy-MM-dd').format(pattern: 'dd MMMM yyyy');
          final formattedNext =
              Jiffy.parse(nextDate, pattern: 'yyyy-MM-dd').format(pattern: 'dd MMMM yyyy');
          availableDatesMessage = "Horaires disponibles les $formattedPrev ou $formattedNext";
        } else if (previousDate != null && previousDate.isNotEmpty) {
          final formattedPrev =
              Jiffy.parse(previousDate, pattern: 'yyyy-MM-dd').format(pattern: 'dd MMMM yyyy');
          availableDatesMessage = "Horaire disponible le $formattedPrev";
        } else if (nextDate != null && nextDate.isNotEmpty) {
          final formattedNext =
              Jiffy.parse(nextDate, pattern: 'yyyy-MM-dd').format(pattern: 'dd MMMM yyyy');
          availableDatesMessage = "Horaire disponible le $formattedNext";
        } else {
          availableDatesMessage = "Aucun horaire disponible pour cette date.";
        }

        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(availableDatesMessage, textAlign: TextAlign.center),
            ],
          ),
        );
      } else {
        return SelectHourInput(
          controller: _hourController,
          slots: hours,
        );
      }
    }
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  void _fetchAppointmentsAvailability() {
    if (widget.medicalConcernId == null) {
      return;
    }

    if (_dateController.text.isEmpty) {
      return;
    }
    final appointmentFlowBloc = context.read<AppointmentFlowBloc>();
    appointmentFlowBloc.add(GetAppointmentsAvailability(
      medicalConcernId: widget.medicalConcernId!,
      date: _dateController.text,
    ));
  }
}
