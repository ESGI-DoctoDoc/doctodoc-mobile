import 'package:doctodoc_mobile/models/appointment/appointment.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/appointment_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../screens/appointments/appointment_detail_screen.dart';
import '../../utils/show_error_snackbar.dart';

class AppointmentCard extends StatefulWidget {
  final Appointment appointment;

  const AppointmentCard({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  void initState() {
    super.initState();
    Jiffy.setLocale('fr-FR');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppointmentDetailScreen.navigateTo(context, widget.appointment.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withAlpha(50),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: AppointmentListTile(
                title: "Dr. ${widget.appointment.doctor.firstName} ${widget.appointment.doctor.lastName}",
                subtitle: widget.appointment.doctor.speciality,
                pictureUrl: widget.appointment.doctor.pictureUrl,
                color: Colors.white,
                trailing: IconButton(
                  onPressed: () {
                    _openMap(widget.appointment.address);
                  },
                  icon: Icon(
                    DateTime.now().isAfter(DateTime.parse('${widget.appointment.date} ${widget.appointment.end}'))
                      ? Icons.check_circle_outline
                      : Icons.directions_outlined,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, color: Colors.green.shade900, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        Jiffy.parse(widget.appointment.date).format(pattern: "dd MMMM yyyy"),
                        style: TextStyle(color: Colors.green.shade900, fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    height: 24,
                    width: 1,
                    color: Colors.green.shade900,
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time_outlined, color: Colors.green.shade900, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        "${widget.appointment.start} - ${widget.appointment.end}",
                        style: TextStyle(color: Colors.green.shade900, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openMap(String address) async {
    final Uri uri =
    Uri.parse(Uri.encodeFull('https://www.google.com/maps/search/?api=1&query=$address'));

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showErrorSnackbar(context, "Impossible d'ouvrir la carte.");
    }
  }
}
