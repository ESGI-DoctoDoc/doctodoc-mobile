import 'package:doctodoc_mobile/screens/medicals/medical_documents_type_screen.dart';
import 'package:flutter/material.dart';

class MedicalPatientDetailsScreen extends StatefulWidget {
  final String patientId;

  static const String routeName = '/patients/:patientId/medical';

  static void navigateTo(BuildContext context, {required String patientId}) {
    Navigator.of(context).pushNamed(routeName, arguments: {
      'patientId': patientId,
    });
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['patientId'] is String) {
      return MedicalPatientDetailsScreen(patientId: arguments['patientId'] as String);
    }

    return const Center(child: Text('Patient not found'));
  }

  const MedicalPatientDetailsScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<MedicalPatientDetailsScreen> createState() => _MedicalPatientDetailsScreenState();
}

class _MedicalPatientDetailsScreenState extends State<MedicalPatientDetailsScreen> {
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
                  'Toutes les analyses',
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
                  'Tous les vaccins',
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
                  'Toutes les ordonnances',
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
                  'tous les documents médicaux',
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
