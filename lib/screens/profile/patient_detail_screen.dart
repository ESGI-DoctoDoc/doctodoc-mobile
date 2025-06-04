import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/update_patient_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/modals/confirm_modal.dart';

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
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      //todo mélissa ici récup le patient en entier puis le donner à la modale
                      final patient = Patient(
                        id: "id",
                        lastName: "lastName",
                        firstName: "firstName",
                        gender: "MALE",
                        email: "c.lechene@myges.fr",
                        phoneNumber: "0675704647",
                      );
                      showUpdatePatientModal(context, patient);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.edit, size: 18,),
                    ),
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

              // // Medical
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Text(
              //     'Dossier médical',
              //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // ListTile(
              //   title: const Text('Mes documents médicaux'),
              //   trailing: const Icon(Icons.chevron_right),
              //   onTap: () => MedicalScreen.navigateTo(context, patientId: widget.patientId),
              // ),

              //todo mélissa delete que si c'est pas le propriétaire du compte
              //todo si tu veux éviter tu peux juste créer un autre fichier identique genre moi et les autres
              ListTile(
                leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                title: Text(
                  'Supprimer le proche',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final shouldDelete = await showConfirmModal(
                    context,
                    'Êtes-vous sûr de vouloir supprimer ce proche ? Cette action est irréversible.',
                  );

                  if (shouldDelete == true) {
                    // TODO mélissa supprimer le patient
                  }
                },
              ),

            ]),
          ),
        ],
      ),
    );
  }
}
