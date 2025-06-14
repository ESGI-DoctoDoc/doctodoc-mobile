import 'package:doctodoc_mobile/shared/widgets/buttons/base/button_base.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/appointment_list_tile.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/base/list_tile_base.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../shared/widgets/banners/info_banner.dart';
import '../../shared/widgets/modals/show_document_care_tracking_upload_modal.dart';
import '../appointments/care_tracking_permissions_screen.dart';

class CareTrackingDetailScreen extends StatefulWidget {
  static const String routeName = '/appointment/:appointmentId';

  static void navigateTo(BuildContext context, String appointmentId) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CareTrackingDetailScreen(appointmentId: appointmentId),
          settings: RouteSettings(name: routeName, arguments: {'appointmentId': appointmentId}),
        ));
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['appointmentId'] is String) {
      return CareTrackingDetailScreen(appointmentId: arguments['appointmentId'] as String);
    } else {
      return const Center(child: Text('Invalid appointment ID'));
    }
  }

  final String appointmentId;

  const CareTrackingDetailScreen({super.key, required this.appointmentId});

  @override
  State<CareTrackingDetailScreen> createState() => _CareTrackingDetailScreenState();
}

class _CareTrackingDetailScreenState extends State<CareTrackingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFEFEF),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          appBar: AppBar(
            title: const Text('_name_'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InfoBanner(
                      title:
                          "Les documents sont strictement confidentiels et accessibles uniquement aux médecins que vous avez autorisés."),
                  const SizedBox(height: 16),
                  _buildDoctor('Dr. John Doe', 'Cardiologist', 'https://exemple.jpg'), // TODO
                  _buildAppointments(),
                  _buildDocuments(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ButtonBase(
                      label: "Modifier les permissions",
                      bgColor: Colors.white,
                      borderColor: Border.all(
                        color: Theme.of(context).dividerColor.withAlpha(77),
                        width: 2,
                      ),
                      onTap: () {
                        CareTrackingPermissionsScreen.navigateTo(context, widget.appointmentId);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctor(String fullName, String specialty, String pictureUrl) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Médecin(s) traitant(s)",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  pictureUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 55,
                      width: 55,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.visibility_off, size: 30, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(specialty, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAppointments() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Tous les rendez-vous",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FixedTimeline.tileBuilder(
            theme: TimelineThemeData(
              nodePosition: 0,
              indicatorTheme: const IndicatorThemeData(
                position: 0.5,
                size: 50.0,
              ),
              connectorTheme: const ConnectorThemeData(
                thickness: 2.5,
              ),
            ),
            builder: TimelineTileBuilder.connected(
              connectionDirection: ConnectionDirection.after,
              itemCount: 3,
              //todo
              contentsBuilder: (_, index) {
                return Column(
                  children: [
                    AppointmentListTile(
                      title: "title",
                      subtitle: "subtitle",
                      pictureUrl: "https://example.com/picture.jpg",
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () {
                          // Navigate to appointment detail
                        },
                      ),
                    ),
                    if (index < 3 - 1)
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
                if (index == 3 - 1) {
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDocuments() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Documents du dossier",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              InkWell(
                child: Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () {
                  showDocumentCareTrackingUploadModal(
                    context,
                    careTrackingId: 'careTrackingId',
                  );
                },
              )
            ],
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < 3; i++)
            ListTileBase.flat(
              title: "Document ${i + 1}",
              subtitle: "Description du document ${i + 1}",
              leading: const Icon(Icons.description),
              trailing: IconButton(
                icon: const Icon(Icons.download, size: 16),
                onPressed: () {
                  // Handle document download
                },
              ),
            ),
        ],
      ),
    );
  }
}
