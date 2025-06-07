import 'package:doctodoc_mobile/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../blocs/close_member_blocs/display_detail_close_member_bloc/display_detail_close_member_bloc.dart';
import '../../blocs/close_member_blocs/write_close_member_bloc/write_close_member_bloc.dart';
import '../../shared/widgets/modals/confirm_modal.dart';
import '../../shared/widgets/modals/update_patient_modal.dart';

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
    _loadCloseMember();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayDetailCloseMemberBloc, DisplayDetailCloseMemberState>(
      builder: (context, state) {
        return switch (state.status) {
          DisplayDetailCloseMemberStatus.initial ||
          DisplayDetailCloseMemberStatus.loading =>
              _buildLoading(),
          DisplayDetailCloseMemberStatus.success => _buildSuccess(state.closeMember),
          DisplayDetailCloseMemberStatus.error => _buildError(),
        };
      },
    );
  }

  Widget _buildLoading() {
    return const Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _loadCloseMember() {
    final displayDetailCloseMemberBloc = context.read<DisplayDetailCloseMemberBloc>();
    displayDetailCloseMemberBloc.add(OnLoadDetailCloseMember(id: widget.patientId));
  }

  Widget _buildSuccess(Patient? closeMember) {
    if (closeMember == null) {
      return _buildError();
    } else {
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
                          id: closeMember.id,
                          lastName: closeMember.lastName,
                          firstName: closeMember.firstName,
                          gender: closeMember.gender,
                          email: closeMember.email,
                          phoneNumber: closeMember.phoneNumber,
                          birthdate: closeMember.birthdate,
                        );
                        showUpdatePatientModal(context, patient);
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
            buildBody(closeMember),
          ],
        ),
      );
    }
  }

  Widget buildBody(Patient closeMember) {
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
          leading: Icon(closeMember.gender == 'MALE' ? Icons.male : Icons.female),
          title: Text(closeMember.gender == 'MALE' ? 'Homme' : 'Femme'),
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
            "${closeMember.lastName[0].toUpperCase()}${closeMember.lastName.substring(1).toLowerCase()} "
                "${closeMember.firstName[0].toUpperCase()}${closeMember.firstName.substring(1).toLowerCase()}",
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
            Jiffy.parse(closeMember.birthdate, pattern: 'yyyy-MM-dd').format(pattern: 'dd/MM/yyyy'),
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
          title: Text(closeMember.email),
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
          title: Text(closeMember.phoneNumber),
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

        // todo créer un autre fichier identique genre moi et les autres
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
              _onDeleteCloseMember();
            }
          },
        ),
      ]),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  _onDeleteCloseMember() {
    final writeCloseMemberBloc = context.read<WriteCloseMemberBloc>();
    writeCloseMemberBloc.add(OnDeleteCloseMember(id: widget.patientId));
    Navigator.pop(context);
  }
}
