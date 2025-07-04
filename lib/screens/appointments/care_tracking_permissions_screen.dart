import 'package:doctodoc_mobile/blocs/document/write_document_in_care_tracking_bloc/write_document_in_care_tracking_bloc.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:doctodoc_mobile/shared/widgets/banners/info_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/care_tracking_detail_blocs/care_tracking_detail_bloc/care_tracking_detail_bloc.dart';
import '../../models/document.dart';
import '../../shared/widgets/list_tile/document_list_tile.dart';

class CareTrackingPermissionsScreen extends StatefulWidget {
  static const String routeName = '/appointment/:appointmentId/permissions';

  static void navigateTo(BuildContext context, String appointmentId) {
    Navigator.pushNamed(context, routeName, arguments: {
      'appointmentId': appointmentId,
    });
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['appointmentId'] is String) {
      return CareTrackingPermissionsScreen(appointmentId: arguments['appointmentId'] as String);
    } else {
      return const Center(child: Text('Invalid appointment ID'));
    }
  }

  final String appointmentId;

  const CareTrackingPermissionsScreen({super.key, required this.appointmentId});

  @override
  State<CareTrackingPermissionsScreen> createState() => _CareTrackingPermissionsScreenState();
}

class _CareTrackingPermissionsScreenState extends State<CareTrackingPermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFEFEF),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          appBar: AppBar(
            title: const Text('Permissions'),
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
                          "Tant que vous n'avez pas autorisé le partage de vos documents, ils ne seront pas accessibles aux médecins."),
                  _buildHeader(),
                  BlocBuilder<CareTrackingDetailBloc, CareTrackingDetailState>(
                    builder: (context, state) {
                      return switch (state) {
                        CareTrackingDetailInitial() ||
                        CareTrackingDetailLoading() =>
                          const OnboardingLoading(),
                        CareTrackingDetailError() => _buildError(),
                        CareTrackingDetailLoaded() =>
                          Column(children: _buildFiles(state.careTracking.documents)),
                      };
                      // return _buildFiles([]);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Autoriser chaque fichier à être partagé avec les professionnels de santé.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFiles(List<Document> documents) {
    Widget buildFileTile(Document doc) {
      return DocumentListTile(
        document: doc,
        trailing: Transform.scale(
          scale: 0.75,
          child: Switch(
            value: doc.isShared,
            onChanged: (bool newValue) {
              _onShareDocument(doc);
            },
          ),
        ),
      );
    }

    return documents.map((doc) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: buildFileTile(doc),
      );
    }).toList();
  }

  void _onShareDocument(Document doc) {
    context.read<WriteDocumentInCareTrackingBloc>().add(OnShareDocument(
          careTrackingId: widget.appointmentId,
          document: doc,
        ));
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }
}
