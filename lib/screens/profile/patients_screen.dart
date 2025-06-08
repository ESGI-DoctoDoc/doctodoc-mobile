import 'package:doctodoc_mobile/models/user.dart';
import 'package:doctodoc_mobile/screens/profile/patient_detail_screen.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/create_patient_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/user_blocs/user_bloc/user_bloc.dart';
import '../appointment/widgets/onboarding_loading.dart';

class PatientsScreen extends StatefulWidget {
  static const String routeName = '/patients';

  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, routeName);
  }

  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  @override
  void initState() {
    super.initState();
    _loadCloseMembers();
  }

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
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showCreatePatientModal(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.add),
                    ),
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
                title: const Text(
                  'Corentin Lechene',
                  style: TextStyle(fontSize: 18, letterSpacing: 0.5),
                ),
                //Todo me
                trailing: const Icon(Icons.chevron_right),
                subtitle: const Text('c.lechene@myges.fr'),
                //Todo me
                onTap: () => PatientDetailsScreen.navigateTo(context, patientId: "0"), //Todo me
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Membres de ma famille',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return switch (state) {
                    UserLoaded() => _buildUserLoadedSuccess(state),
                    UserState() => _buildError(),
                  };
                },
              )
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildUserLoadedSuccess(UserLoaded state) {
    return switch (state.getCloseMembersStatus) {
      GetCloseMembersStatus.initial || GetCloseMembersStatus.loading => const OnboardingLoading(),
      GetCloseMembersStatus.success => _buildSuccess(state.user),
      GetCloseMembersStatus.error => _buildError(),
    };
  }

  Widget _buildSuccess(User user) {
    final closeMembers = user.closeMembers;
    if (closeMembers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text("Vous n'avez pas encore de membres proches."),
      );
    }

    return Column(
      children: closeMembers.map((member) {
        return ListTile(
          leading: Icon(
            Icons.person,
            color: member.gender == 'MALE'
                ? Colors.blue
                : member.gender == 'FEMALE'
                    ? Colors.pink
                    : null,
          ),
          title: Text(
            '${member.firstName[0].toUpperCase()}${member.firstName.substring(1).toLowerCase()} ${member.lastName[0].toUpperCase()}${member.lastName.substring(1).toLowerCase()}',
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Text(member.email),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => PatientDetailsScreen.navigateTo(context, patientId: member.id),
        );
      }).toList(),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  _loadCloseMembers() {
    final userBloc = context.read<UserBloc>();
    userBloc.add(OnUserLoadedCloseMembers());
  }
}
