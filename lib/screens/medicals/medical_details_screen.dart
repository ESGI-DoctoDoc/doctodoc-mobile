import 'package:flutter/material.dart';

import '../../models/document.dart';
import 'medical_documents_type_screen.dart';

class MedicalDetailsScreen extends StatefulWidget {
  final String patientId;

  static const String routeName = '/profile/medical';

  static void navigateTo(BuildContext context, {required String patientId}) {
    Navigator.of(context).pushNamed(routeName, arguments: {
      'patientId': patientId,
    });
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['patientId'] is String) {
      return MedicalDetailsScreen(patientId: arguments['patientId'] as String);
    }

    return const Center(child: Text('Patient not found'));
  }

  const MedicalDetailsScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<MedicalDetailsScreen> createState() => _MedicalDetailsScreenState();
}

class _MedicalDetailsScreenState extends State<MedicalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            floating: true,
            snap: true,
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      child: const Icon(Icons.chevron_left),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Text(
                    'Dossier médical',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              background: Container(
                color: Color(0xFFEFEFEF),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ...DocumentType.values.map((docType) {
                IconData icon;
                switch (docType) {
                  case DocumentType.medicalReport:
                    icon = Icons.description;
                    break;
                  case DocumentType.prescription:
                    icon = Icons.receipt;
                    break;
                  case DocumentType.medicalCertificate:
                    icon = Icons.assignment_turned_in;
                    break;
                  case DocumentType.analysesResult:
                    icon = Icons.science;
                    break;
                  case DocumentType.other:
                    icon = Icons.image;
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(icon),
                        title: Text(docType.label),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          MedicalDocumentsTypeScreen.navigateTo(
                            context,
                            patientId: widget.patientId,
                            type: docType.name,
                          );
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ]),
          ),
        ],
      ),
    );
  }
}
