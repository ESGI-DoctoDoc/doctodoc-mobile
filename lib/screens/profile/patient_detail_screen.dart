import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/screens/medicals/medical_screen.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/update_patient_modal.dart';
import 'package:flutter/material.dart';

class PatientDetailsScreen extends StatefulWidget {
  final String patientId;

  static const String routeName = '/patients/:patient_id';

  static void navigateTo(BuildContext context, {required String patientId}) {
    Navigator.of(context).pushNamed(routeName, arguments: {
      'patientId': patientId,
    });
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['patientId'] is String) {
      return PatientDetailsScreen(patientId: arguments['patientId'] as String);
    }
    return const Center(child: Text('Patient not found'));
  }

  const PatientDetailsScreen({super.key, required this.patientId});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    'Mes informations',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              background: Container(
                color: Colors.white,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Nom et prénom',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('Corentin LECHENE'), //Todo me
                onTap: () => PatientDetailsScreen.navigateTo(context, patientId: "0"), //Todo me
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('c.lechene@myges.fr'), //Todo me
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Téléphone',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('06 12 34 56 78'), //Todo me
              ),

              const SizedBox(height: 24),

              // Medical
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Dossier médical',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('Mes documents médicaux'), //Todo me
                trailing: const Icon(Icons.chevron_right),
                onTap: () => MedicalScreen.navigateTo(context, patientId: widget.patientId),
              ),

              const SizedBox(height: 50),
              PrimaryButton(
                label: "Modifier mes informations",
                onTap: () {
                  final patient = Patient(
                    id: "id",
                    lastName: "lastName",
                    firstName: "firstName",
                    gender: "gender",
                    email: "email",
                    phoneNumber: "phoneNumber",
                  );
                  showUpdatePatientModal(context, patient);
                },
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: "voir le dossier médical",
                onTap: () {
                  MedicalScreen.navigateTo(context, patientId: widget.patientId);
                },
              )
            ]),
          ),
        ],
      ),
    );
  }
}
