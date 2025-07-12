import 'package:doctodoc_mobile/models/care_tracking.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/base/expansion_tile_base.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/care_tracking_menu_modal.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timelines_plus/timelines_plus.dart';

import 'appointment_list_tile.dart';

class CareTrackingListTile extends StatefulWidget {
  final CareTracking careTracking;

  const CareTrackingListTile({
    super.key,
    required this.careTracking,
  });

  @override
  State<CareTrackingListTile> createState() => _CareTrackingListTileState();
}

class _CareTrackingListTileState extends State<CareTrackingListTile> {
  @override
  void initState() {
    super.initState();
    Jiffy.setLocale('fr-FR');
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTileBase(
      title: widget.careTracking.name,
      subtitle: widget.careTracking.closedAt.isNotEmpty
          ? "Clôturé le ${Jiffy.parse(widget.careTracking.closedAt, pattern: 'yyyy-MM-dd HH:mm').format(pattern: 'd MMM yyyy à HH:mm')}"
          : "En cours...",
      trailing: IconButton(
        onPressed: () => showCareTrackingMenuModal(context, widget.careTracking.id),
        icon: Icon(Icons.more_vert),
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Icon(Icons.folder_shared_outlined, color: Colors.blue.shade900),
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            //only top
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildAppointmentsList(widget.careTracking.appointments),
          ),
        )
      ],
    );
  }

  List<Widget> _buildAppointmentsList(List<AppointmentOfCareTracking> appointments) {
    return [
      FixedTimeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          indicatorTheme: const IndicatorThemeData(
            position: 0.5,
            size: 20.0,
          ),
          connectorTheme: const ConnectorThemeData(
            thickness: 2.5,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.after,
          itemCount: appointments.length,
          contentsBuilder: (_, index) {
            AppointmentOfCareTracking appointment = appointments[index];

            return Column(
              children: [
                AppointmentListTile(
                  title: "Dr. ${appointment.doctor.firstName} ${appointment.doctor.lastName}",
                  subtitle: Jiffy.parse("${appointment.date} ${appointment.start}",
                          pattern: 'yyyy-MM-dd HH:mm')
                      .format(pattern: 'd MMM yyyy à HH:mm'),
                  pictureUrl: appointment.doctor.pictureUrl,
                ),
                if (index < appointments.length - 1)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 0.5,
                      height: 16,
                    ),
                  ),
              ],
            );
          },
          indicatorBuilder: (_, index) {
            if (index == appointments.length - 1) {
              return OutlinedDotIndicator(
                size: 12.0,
                borderWidth: 2.0,
                color: Theme.of(context).primaryColor,
              );
            }
            return DotIndicator(
              size: 12.0,
              color: Theme.of(context).primaryColor,
            );
          },
          connectorBuilder: (_, index, ___) {
            return SolidLineConnector(
              color: Theme.of(context).primaryColor,
            );
          },
        ),
      ),
    ];
  }
}
