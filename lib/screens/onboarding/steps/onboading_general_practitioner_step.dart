import 'package:doctodoc_mobile/shared/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';

import '../../../models/doctor/doctor.dart';
import '../../../shared/widgets/inputs/doctor_search_bar.dart';
import '../../../shared/widgets/list_tile/doctor_list_tile.dart';
import '../../../shared/widgets/modals/showInviteDoctorModal.dart';

class OnboardingGeneralPractitionerStep extends StatefulWidget {
  final void Function(String generalPractitioner) onFinished;
  final void Function() onSkip;

  const OnboardingGeneralPractitionerStep({
    super.key,
    required this.onFinished,
    required this.onSkip,
  });

  @override
  State<OnboardingGeneralPractitionerStep> createState() =>
      _OnboardingGeneralPractitionerStepState();
}

class _OnboardingGeneralPractitionerStepState extends State<OnboardingGeneralPractitionerStep> {
  final TextEditingController generalPractitionerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _name = '';
  bool _isLoadingMore = false;
  String? _selectedDoctorId;
  bool canInviteDoctor = true;

  @override
  void initState() {
    super.initState();
    widget.onSkip();
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
                // _loadingInitialDoctorSearch();
              },
            ),
            const SizedBox(height: 8.0),
            const Text("Vous pouvez aussi passer cette étape"),
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
                child: _buildSuccess([
                  // Doctor(id: '1', speciality: 'General Practitioner', firstName: '', lastName: '', pictureUrl: ''),
                  // Doctor(id: '2', speciality: 'General Practitioner', firstName: '', lastName: '', pictureUrl: ''),
                  // Doctor(id: '2', speciality: 'General Practitioner', firstName: '', lastName: '', pictureUrl: ''),
                  // Doctor(id: '2', speciality: 'General Practitioner', firstName: '', lastName: '', pictureUrl: ''),
                  // Doctor(id: '2', speciality: 'General Practitioner', firstName: '', lastName: '', pictureUrl: ''),
                  Doctor(id: '2', speciality: 'General Practitioner', firstName: '', lastName: '', pictureUrl: ''),
                  Doctor(id: '2', speciality: 'General Practitioner', firstName: '', lastName: '', pictureUrl: ''),
                  Doctor(id: '2', speciality: 'General Practitioner', firstName: '', lastName: '', pictureUrl: ''),
                ], false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess(List<Doctor> doctors, bool isLoadingMore) {
    _isLoadingMore = isLoadingMore;

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
        if(canInviteDoctor == false) {
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
                  if(send == true) {
                    canInviteDoctor = false;
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

  // void _loadingInitialDoctorSearch() {
  //   final displayDoctor = context.read<DisplayDoctorBloc>();
  //   displayDoctor.add(OnGetInitialSearchDoctor(
  //     name: _name,
  //     speciality: _filters?['speciality'] ?? '',
  //     languages: _filters?['languages'] ?? '',
  //   ));
  // }

  // void _loadNextDoctorSearch() {
  //   final displayDoctor = context.read<DisplayDoctorBloc>();
  //   displayDoctor.add(OnGetNextSearchDoctor(
  //     name: _name,
  //     speciality: _filters?['speciality'] ?? '',
  //     languages: _filters?['languages'] ?? '',
  //   ));
  // }
}
