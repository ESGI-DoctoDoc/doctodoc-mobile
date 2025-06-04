import 'package:doctodoc_mobile/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/close_member_blocs/display_detail_close_member_bloc/display_detail_close_member_bloc.dart';
import '../../blocs/write_close_member_bloc/write_close_member_bloc.dart';
import '../../shared/widgets/modals/confirm_modal.dart';
import '../../shared/widgets/modals/update_patient_modal.dart';
import '../appointment/widgets/onboarding_loading.dart';

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
            const OnboardingLoading(),
          DisplayDetailCloseMemberStatus.success => _buildSuccess(state.closeMember),
          DisplayDetailCloseMemberStatus.error => _buildError(),
        };
      },
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
                  color: Colors.white,
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
            'Nom et prénom',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text("${closeMember.lastName} ${closeMember.firstName}"), //Todo me
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
          title: Text(closeMember.email), //Todo me
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Téléphone',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text(closeMember.phoneNumber), //Todo me
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
