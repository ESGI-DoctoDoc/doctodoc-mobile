import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/update_profile_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../blocs/user_blocs/user_bloc/user_bloc.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final String patientId;

  static const String routeName = '/profile';

  static void navigateTo(BuildContext context, {required String patientId}) {
    Navigator.of(context).pushNamed(routeName, arguments: {
      'patientId': patientId,
    });
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['patientId'] is String) {
      return ProfileDetailsScreen(patientId: arguments['patientId'] as String);
    }
    return const Center(child: Text('Patient not found'));
  }

  const ProfileDetailsScreen({super.key, required this.patientId});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final userBloc = context.read<UserBloc>();
    userBloc.add(OnUserLoadedBasicInfos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return switch (state) {
          UserLoading() || UserInitial() => const CircularProgressIndicator(),
          UserLoaded() => _buildSuccess(state.user.patientInfos),
          UserError() || UserState() => _buildError(),
        };
      },
    );
  }

  Widget _buildSuccess(Patient userPatientInfos) {
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
                    'Mes informations',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      final patient = Patient(
                        id: userPatientInfos.id,
                        lastName: userPatientInfos.lastName,
                        firstName: userPatientInfos.firstName,
                        gender: userPatientInfos.gender,
                        email: userPatientInfos.email,
                        phoneNumber: userPatientInfos.phoneNumber,
                        birthdate: userPatientInfos.birthdate,
                      );
                      showUpdateProfileModal(context, patient);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.edit,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              background: Container(
                color: Color(0xFFEFEFEF),
              ),
            ),
          ),
          buildBody(userPatientInfos),
        ],
      ),
    );
  }

  Widget buildBody(Patient currentUser) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Genre',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: Icon(currentUser.gender == 'MALE' ? Icons.male : Icons.female),
          title: Text(currentUser.gender == 'MALE' ? 'Homme' : 'Femme'),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Nom et prénom',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.badge),
          title: Text(
            "${currentUser.lastName[0].toUpperCase()}${currentUser.lastName.substring(1).toLowerCase()} "
            "${currentUser.firstName[0].toUpperCase()}${currentUser.firstName.substring(1).toLowerCase()}",
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Date de naissance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.cake),
          title: Text(
            Jiffy.parse(currentUser.birthdate, pattern: 'yyyy-MM-dd').format(pattern: 'dd/MM/yyyy'),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Email',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: Text(currentUser.email),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Téléphone',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.phone),
          title: Text(currentUser.phoneNumber),
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
      ]),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }
}
