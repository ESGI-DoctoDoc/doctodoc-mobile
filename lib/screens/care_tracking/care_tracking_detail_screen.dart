import 'package:doctodoc_mobile/blocs/care_tracking_detail_blocs/care_tracking_detail_bloc/care_tracking_detail_bloc.dart';
import 'package:doctodoc_mobile/models/care_tracking.dart';
import 'package:doctodoc_mobile/models/doctor/doctor.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:doctodoc_mobile/screens/appointments/appointment_detail_screen.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/appointment_list_tile.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/base/list_tile_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../shared/widgets/modals/document_care_tracking_menu_modal.dart';
import '../../shared/widgets/modals/show_document_care_tracking_upload_modal.dart';

class CareTrackingDetailScreen extends StatefulWidget {
  static const String routeName = '/care-trackings/:careTrackingId';

  static void navigateTo(BuildContext context, String careTrackingId) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CareTrackingDetailScreen(careTrackingId: careTrackingId),
          settings: RouteSettings(name: routeName, arguments: {'careTrackingId': careTrackingId}),
        ));
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['careTrackingId'] is String) {
      return CareTrackingDetailScreen(careTrackingId: arguments['careTrackingId'] as String);
    } else {
      return const Center(child: Text('Invalid appointment ID'));
    }
  }

  final String careTrackingId;

  const CareTrackingDetailScreen({super.key, required this.careTrackingId});

  @override
  State<CareTrackingDetailScreen> createState() => _CareTrackingDetailScreenState();
}

class _CareTrackingDetailScreenState extends State<CareTrackingDetailScreen> {
  @override
  void initState() {
    super.initState();
    _getCareTrackingDetailed();
    Jiffy.setLocale('fr-FR');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFEFEF),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          appBar: AppBar(
            title: BlocBuilder<CareTrackingDetailBloc, CareTrackingDetailState>(
              builder: (context, state) {
                return switch (state) {
                  CareTrackingDetailInitial() ||
                  CareTrackingDetailLoading() =>
                    const OnboardingLoading(),
                  CareTrackingDetailError() => _buildError(),
                  CareTrackingDetailLoaded() => Text(_capitalize(state.careTracking.careTracking.name.toLowerCase())),
                };
              },
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<CareTrackingDetailBloc, CareTrackingDetailState>(
                builder: (context, state) {
                  return switch (state) {
                    CareTrackingDetailInitial() ||
                    CareTrackingDetailLoading() =>
                      const OnboardingLoading(),
                    CareTrackingDetailError() => _buildError(),
                    CareTrackingDetailLoaded() => _buildSuccess(context, state.careTracking),
                  };
                  // return _buildSuccess(context);
                },
              ),
            ),
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

  Column _buildSuccess(BuildContext context, CareTrackingDetailed careTracking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildDescription(careTracking.careTracking.description),
        const SizedBox(height: 16),
        _buildDoctors(careTracking.doctors),
        _buildAppointments(careTracking.appointments),
        _buildDocuments(careTracking.documents),
      ],
    );
  }

  Widget _buildDescription(String description) {
    return Container(
      width: double.infinity,
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
            "Description",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildDoctors(List<Doctor> doctors) {
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
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: doctors.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16.0),
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      doctor.pictureUrl,
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
                          "${_capitalize(doctor.firstName.toLowerCase())} ${_capitalize(doctor.lastName.toLowerCase())}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(doctor.speciality, style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppointments(List<AppointmentOfCareTracking> appointments) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      width: double.infinity,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Tous les rendez-vous",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          appointments.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Aucun rendez-vous n'est associé à ce suivi de dossier.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : FixedTimeline.tileBuilder(
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
                    itemCount: appointments.length,
                    contentsBuilder: (_, index) {
                      AppointmentOfCareTracking appointment = appointments[index];

                      return Column(
                        children: [
                          AppointmentListTile(
                            title:
                                "Dr. ${appointment.doctor.firstName} ${appointment.doctor.lastName}",
                            subtitle: Jiffy.parse("${appointment.date} ${appointment.start}",
                                    pattern: 'yyyy-MM-dd HH:mm')
                                .format(pattern: 'd MMM yyyy à HH:mm'),
                            pictureUrl: appointment.doctor.pictureUrl,
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, size: 16),
                              onPressed: () {
                                AppointmentDetailScreen.navigateTo(
                                  context,
                                  appointment.id,
                                );
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

  Widget _buildDocuments(List<Document> documents) {
    final initialDocs = documents.take(3).toList();
    final hasMore = documents.length > 3;

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
                    careTrackingId: widget.careTrackingId,
                  );
                },
              )
            ],
          ),
          const SizedBox(height: 16),
          if (!hasMore)
            ..._buildDocumentList(documents)
          else ...[
            ..._buildDocumentList(initialDocs),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Afficher tous les documents"),
              ),
              childrenPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, side: BorderSide.none),
              collapsedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, side: BorderSide.none),
              children: _buildDocumentList(documents.skip(3).toList()),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildDocumentList(List<Document> documents) {
    return List.generate(
      documents.length,
      (i) {
        final document = documents[i];
        return ListTileBase.flat(
          title: document.name,
          subtitle: document.type,
          leading: const Icon(Icons.description),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showDocumentCareTrackingMenuModal(
                context,
                document,
                widget.careTrackingId,
              );
            },
          ),
        );
      },
    );
  }

  void _getCareTrackingDetailed() {
    context.read<CareTrackingDetailBloc>().add(OnGetCareTrackingDetail(
          id: widget.careTrackingId,
        ));
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
