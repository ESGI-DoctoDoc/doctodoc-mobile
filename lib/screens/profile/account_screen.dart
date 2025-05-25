import 'package:doctodoc_mobile/screens/profile/patient_detail_screen.dart';
import 'package:doctodoc_mobile/screens/profile/patients_screen.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/change_password_modal.dart';
import 'package:flutter/material.dart';

import '../medicals/medical_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

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
              title: const Text('Compte'),
              background: Container(
                color: Color(0xFFEFEFEF),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Mes informations
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Mes informations',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profil'),
                subtitle: const Text('Corentin LECHENE'),
                //Todo me
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    PatientDetailsScreen.navigateTo(context, patientId: "patientId"), //Todo me
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Ma famille'),
                subtitle: const Text('Gérer les membres de ma famille'),
                //Todo me
                trailing: const Icon(Icons.chevron_right),
                onTap: () => PatientsScreen.navigateTo(context),
              ),
              ListTile(
                leading: const Icon(Icons.folder_shared),
                title: const Text('Dossier médical'),
                subtitle: const Text('Mes documents médicaux'),
                //Todo me
                trailing: const Icon(Icons.chevron_right),
                onTap: () => MedicalScreen.navigateTo(context, patientId: "0"), //Todo me
              ),

              // Moyens de connexion
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Connexion',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text('Email'),
                subtitle: const Text('c.lechene@myges.fr'),
                //Todo me
                trailing: const Icon(Icons.verified, color: Colors.green, size: 18),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: Text('Email'),
                subtitle: const Text('06 12 34 56 78'),
                //Todo me
                trailing: const Icon(Icons.verified, color: Colors.green, size: 18),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Mot de passe'),
                subtitle: const Text('Modifier mon mot de passe'),
                //Todo me
                trailing: const Icon(Icons.edit, size: 18),
                onTap: () => showChangePasswordModal(context),
              ),

              // Confidentialité
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Confidentialité',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Politique de confidentialité'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {}, //Todo me
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text("Conditions d'utilisation"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {}, //Todo me
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Déconnexion'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {}, //Todo me
              ),

              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                title: Text(
                  'Supprimer mon compte',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {}, //Todo me
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Version 0.0.1',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary.withAlpha(77),
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ]),
          ),
        ],
      ),
    );
  }
}
