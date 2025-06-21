import 'package:flutter/material.dart';

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
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Mes analyses',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(Icons.science),
                title: Text('Analyse'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  MedicalDocumentsTypeScreen.navigateTo(context, patientId: "patientId", type: "type");
                },
              ),

              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Mes vaccinations',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(Icons.vaccines),
                title: Text('Vaccin'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  MedicalDocumentsTypeScreen.navigateTo(context, patientId: "patientId", type: "type");
                },
              ),

              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Mes ordonnances',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text('Ordonnance'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  MedicalDocumentsTypeScreen.navigateTo(context, patientId: "patientId", type: "type");
                },
              ),

              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Mes documents médicaux',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Imagerie'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  MedicalDocumentsTypeScreen.navigateTo(context, patientId: "patientId", type: "type");
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
