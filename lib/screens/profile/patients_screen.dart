import 'package:doctodoc_mobile/screens/profile/patient_detail_screen.dart';
import 'package:flutter/material.dart';

class PatientsScreen extends StatelessWidget {
  static const String routeName = '/patients';

  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, routeName);
  }

  const PatientsScreen({super.key});

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
                    'Mes patients',
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
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Moi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Corentin LECHENE'), //Todo me
                trailing: const Icon(Icons.chevron_right),
                subtitle: const Text('c.lechene@myges.fr'), //Todo me
                onTap: () => PatientDetailsScreen.navigateTo(context, patientId: "0"), //Todo me
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Membres de ma famille',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ...[1, 2, 3].map((patient) => ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Patient Name'), //Todo me
                    subtitle: Text('c.lechene+$patient@gmail.com'), //Todo me
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => PatientDetailsScreen.navigateTo(context, patientId: "$patient"), //Todo me
                  )),
            ]),
          ),
        ],
      ),
    );
  }
}
