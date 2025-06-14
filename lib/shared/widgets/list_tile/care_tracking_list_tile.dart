import 'package:doctodoc_mobile/shared/widgets/list_tile/appointment_list_tile.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/base/expansion_tile_base.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/care_tracking_menu_modal.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class CareTrackingListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String pictureUrl;

  const CareTrackingListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.pictureUrl,
  });

  @override
  State<CareTrackingListTile> createState() => _CareTrackingListTileState();
}

class _CareTrackingListTileState extends State<CareTrackingListTile> {
  final List<String> appointments = [
    "Appointment 1",
    "Appointment 2",
    "Appointment 3",
  ];

  @override
  Widget build(BuildContext context) {
    return ExpansionTileBase(
      title: widget.title,
      trailing: IconButton(
        onPressed: () => showCareTrackingMenuModal(context),
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
            children: _buildAppointmentsList(context),
          ),
        )
      ],
    );
  }

  List<Widget> _buildAppointmentsList(BuildContext context) {
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
            return Column(
              children: [
                AppointmentListTile(
                  title: widget.title,
                  subtitle: widget.subtitle,
                  pictureUrl: widget.pictureUrl,
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
