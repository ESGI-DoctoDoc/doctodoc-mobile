import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../shared/widgets/maps/maps_viewer.dart';
import '../appointment_screen.dart';

class _AppointmentConfirmWidget extends StatefulWidget {
  final AppointmentData appointmentData;

  const _AppointmentConfirmWidget({
    super.key,
    required this.appointmentData,
  });

  @override
  State<_AppointmentConfirmWidget> createState() => _AppointmentConfirmWidgetState();
}

class _AppointmentConfirmWidgetState extends State<_AppointmentConfirmWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  leading: Icon(Icons.calendar_today),
                  title: Text(
                    "Date et heure",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(_formatDate()),
                ),
                Divider(color: const Color(0xFFe0e0e0), thickness: 2),
                ListTile(
                  leading: Icon(Icons.medical_services),
                  title: Text(
                    "Médecin",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("Dr. Jean Dupont"),
                ),
                Divider(color: const Color(0xFFe0e0e0), thickness: 2),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Patient",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("Oihana LECHENE"),
                ),
                Divider(color: const Color(0xFFe0e0e0), thickness: 2),
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
                      widget.appointmentData.latitude,
                      widget.appointmentData.longitude,
                    ),
                    marker: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(widget.appointmentData.doctorPictureUrl),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(label: "Confirmer le rendez-vous", onTap: () {}),
        ],
      ),
    );
  }

  String _formatDate() {
    final date = widget.appointmentData.date;
    if (date == null) {
      return "Date non spécifiée";
    }
    return "Mardi 15 Août 2023 à 14h30";
  }
}

void showAppointmentConfirmationModal(BuildContext context, AppointmentData appointmentData) {
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
            onPressed: Navigator.of(context).pop,
          ),
          child: _AppointmentConfirmWidget(appointmentData: appointmentData),
        )
      ];
    },
  );
}
