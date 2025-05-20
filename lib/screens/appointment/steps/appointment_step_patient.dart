import 'package:doctodoc_mobile/blocs/user_bloc/user_bloc.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/appointment_label.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/create_patient_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user.dart';
import '../../../shared/widgets/inputs/patient_selection.dart';
import '../widgets/onboarding_loading.dart';

class AppointmentStepPatient extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(PatientItem) onNext;

  const AppointmentStepPatient({
    super.key,
    required this.formKey,
    required this.onNext,
  });

  @override
  State<AppointmentStepPatient> createState() => _AppointmentStepPatientState();
}

class _AppointmentStepPatientState extends State<AppointmentStepPatient> {
  final TextEditingController _patientController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCloseMembers();
  }

  @override
  void dispose() {
    super.dispose();
    _patientController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return switch (state) {
          UserLoaded() => _buildUserLoadedSuccess(state),
          UserState() => _buildError(),
        };
      },
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
    final patients = [...user.closeMembers, user.patientInfos];
    List<PatientItem> patientItems = [];

    patientItems.addAll(
      patients.map(
        (patient) => PatientItem(
          patientId: patient.id,
          firstname: patient.firstName,
          lastname: patient.lastName,
        ),
      ),
    );

    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              AppointmentLabel(
                label: "Selectionner le patient",
                onTap: () async {
                  final patient = await showCreatePatientModal(context);
                  if (patient != null) {
                    final newPatient = PatientItem(
                      patientId: patient.id,
                      firstname: patient.firstName,
                      lastname: patient.lastName,
                    );

                    setState(() {
                      patientItems.add(newPatient);
                    });
                  }
                },
              ),
              PatientSelection(
                controller: _patientController,
                patients: patientItems,
                onChange: (patient) {
                  widget.onNext(patient);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  void _fetchCloseMembers() {
    final userBloc = context.read<UserBloc>();
    userBloc.add(OnUserLoadedCloseMembers());
  }
}
