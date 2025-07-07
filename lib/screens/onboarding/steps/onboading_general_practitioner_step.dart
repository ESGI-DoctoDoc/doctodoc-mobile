import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/doctor_blocs/display_doctor_bloc/display_doctor_bloc.dart';
import '../../../models/doctor/doctor.dart';
import '../../../shared/widgets/inputs/doctor_search_bar.dart';
import '../../../shared/widgets/list_tile/doctor_list_tile.dart';
import '../../../shared/widgets/modals/showInviteDoctorModal.dart';

class OnboardingGeneralPractitionerStep extends StatefulWidget {
  final void Function(String generalPractitioner) onFinished;
  final void Function() onSkip;
  final void Function() onEnd;

  const OnboardingGeneralPractitionerStep({
    super.key,
    required this.onFinished,
    required this.onSkip,
    required this.onEnd,
  });

  @override
  State<OnboardingGeneralPractitionerStep> createState() =>
      _OnboardingGeneralPractitionerStepState();
}

class _OnboardingGeneralPractitionerStepState extends State<OnboardingGeneralPractitionerStep> {
  final TextEditingController generalPractitionerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _name = '';
  final String _speciality = 'Généraliste';
  bool _isLoadingMore = false;
  String? _selectedDoctorId;
  bool canInviteDoctor = true;

  @override
  void initState() {
    super.initState();
    widget.onSkip();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
        _isLoadingMore) {
      _loadNextDoctorSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Qui est votre médecin traitant ?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            DoctorSearchBar(
              onSearch: (value) {
                _name = value;
                _loadingInitialDoctorSearch();
              },
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Résultats',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  return false;
                },
                child: BlocBuilder<DisplayDoctorBloc, DisplayDoctorState>(
                  builder: (context, state) {
                    return switch (state.status) {
                      DisplayDoctorStatus.initial => _buildEmpty(),
                      DisplayDoctorStatus.initialLoading =>
                        const OnboardingLoading(),
                      DisplayDoctorStatus.loading ||
                      DisplayDoctorStatus.success =>
                        _buildSuccess(state.doctors, state.isLoadingMore),
                      DisplayDoctorStatus.error => _buildError(),
                    };
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Text("Veuillez faire une recherche !"),
    );
  }

  Widget _buildSuccess(List<Doctor> doctors, bool isLoadingMore) {
    _isLoadingMore = isLoadingMore;

    if(_name.isEmpty) {
      return Center(
        child: Column(
          children: [
            Text("Veuillez faire une recherche !"),
            const Text("Vous pouvez aussi passer cette étape"),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: isLoadingMore ? doctors.length + 2 : doctors.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: 8.0),
      itemBuilder: (context, index) {
        if (index < doctors.length) {
          final doctor = doctors[index];
          return DoctorListTile(
            doctor: doctor,
            trailing: Radio<String>(
              value: doctor.id,
              groupValue: _selectedDoctorId,
              onChanged: (String? value) {
                setState(() {
                  _selectedDoctorId = value;
                });
                if (value != null) {
                  widget.onFinished(value);
                }
              },
            ),
            onTap: () {
              setState(() {
                _selectedDoctorId = doctor.id;
              });
              widget.onFinished(doctor.id);
            },
          );
        }

        if (isLoadingMore && index == doctors.length) {
          return const Center(child: CircularProgressIndicator());
        }

        // Widget à la fin de la liste
        if (canInviteDoctor == false) {
          return Column(
            children: [
              const SizedBox(height: 20),
              const Text("Demande d'invitation envoyée !"),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Si votre médecin n'est pas encore sur DoctoDoc, vous pouvez renseigner ses coordonnées.",
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 12.0),
            SecondaryButton(
              label: "Invitez mon médecin",
              onTap: () async {
                final send = await showInviteDoctorModal(context);
                setState(() {
                  if (send == true) {
                    canInviteDoctor = false;
                    widget.onEnd();
                  }
                });
              },
            ),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  void _loadingInitialDoctorSearch() {
    final displayDoctor = context.read<DisplayDoctorBloc>();
    displayDoctor.add(OnGetInitialSearchDoctor(
      name: _name,
      speciality: _speciality,
      languages: '',
      valid: false,
    ));
  }

  void _loadNextDoctorSearch() {
    final displayDoctor = context.read<DisplayDoctorBloc>();
    displayDoctor.add(OnGetNextSearchDoctor(
      name: _name,
      speciality: _speciality,
      languages: '',
      valid: false,
    ));
  }
}
