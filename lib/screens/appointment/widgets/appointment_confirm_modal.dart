import 'package:doctodoc_mobile/screens/appointment/types/appointment_flow_data.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:latlong2/latlong.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/appointment_blocs/appointment_bloc/appointment_bloc.dart';
import '../../../layout/main_layout.dart';
import '../../../shared/widgets/maps/maps_viewer.dart';

class _AppointmentConfirmWidget extends StatefulWidget {
  final AppointmentFlowDataReview appointmentData;

  const _AppointmentConfirmWidget({
    required this.appointmentData,
  });

  @override
  State<_AppointmentConfirmWidget> createState() => _AppointmentConfirmWidgetState();
}

class _AppointmentConfirmWidgetState extends State<_AppointmentConfirmWidget> {
  @override
  void initState() {
    super.initState();
    Jiffy.setLocale('fr-FR');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentBloc, AppointmentState>(
      listenWhen: appointmentListener,
      listener: (context, state) {
        if(state is AppointmentConfirm && state.status == AppointmentConfirmStatus.success) {
          MainLayout.navigateTo(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFe0e0e0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text(
                      "Date et heure",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(_formatDate()),
                  ),
                  const Divider(color: Color(0xFFe0e0e0), thickness: 2),
                  ListTile(
                    leading: const Icon(Icons.medical_services),
                    title: const Text(
                      "Médecin",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                        "Dr. ${_capitalize(widget.appointmentData.doctorData.firstName.toLowerCase())} ${_capitalize(widget.appointmentData.doctorData.lastName.toLowerCase())}"),
                  ),
                  const Divider(color: Color(0xFFe0e0e0), thickness: 2),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(
                      "Patient",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "${widget.appointmentData.patientData.firstName} ${widget.appointmentData.patientData.lastName}",
                    ),
                  ),
                  const Divider(color: Color(0xFFe0e0e0), thickness: 2),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: 8.0,
                      top: 4.0,
                    ),
                    child: MapsViewer(
                      zoom: 15,
                      center: LatLng(
                        widget.appointmentData.doctorData.address.latitude,
                        widget.appointmentData.doctorData.address.longitude,
                      ),
                      marker: CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(widget.appointmentData.doctorData.pictureUrl),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
                label: "Confirmer le rendez-vous",
                onTap: () {
                  _onConfirmAppointment();
                }),
          ],
        ),
      ),
    );
  }

  bool appointmentListener(previous, current) {
    return previous is AppointmentLocked &&
        (current is AppointmentConfirm && current.status == AppointmentConfirmStatus.success);
  }

  String _formatDate() {
    final date = widget.appointmentData.slotData.date;
    final time = widget.appointmentData.slotData.time;
    final parsedDate = Jiffy.parse(date, pattern: 'yyyy-MM-dd');
    final parsedTime = Jiffy.parse(time, pattern: 'HH:mm');

    Jiffy.setLocale('fr-FR');

    final dateFormatted = _capitalize(parsedDate.format(pattern: 'EEEE d MMMM yyyy'));
    final hour = parsedTime.hour.toString().padLeft(2, '0');
    final minute = parsedTime.minute.toString().padLeft(2, '0');

    return "$dateFormatted à ${hour}h$minute";
  }

  _onConfirmAppointment() {
    final appointmentBloc = context.read<AppointmentBloc>();
    appointmentBloc.add(OnConfirmAppointment());
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}

void showAppointmentConfirmationModal(
    BuildContext context, AppointmentFlowDataReview appointmentData) {
  void onClosedPopUp() {
    final appointmentBloc = context.read<AppointmentBloc>();
    appointmentBloc.add(OnUnlockedAppointment());
    Navigator.of(context).pop();
  }

  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasSabGradient: false,
          hasTopBarLayer: false,
          pageTitle: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Souhaitez-vous confirmer votre rendez-vous ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          trailingNavBarWidget: IconButton(
            padding: const EdgeInsets.all(20),
            icon: const Icon(Icons.close),
            onPressed: onClosedPopUp,
          ),
          child: _AppointmentConfirmWidget(appointmentData: appointmentData),
        ),
      ];
    },
  );
}
