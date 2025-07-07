import 'package:doctodoc_mobile/blocs/doctor_blocs/doctor_recruitment_bloc/doctor_recruitment_bloc.dart';
import 'package:doctodoc_mobile/shared/widgets/banners/info_banner.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/firstname_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/lastname_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/doctor_blocs/display_doctor_bloc/display_doctor_bloc.dart';
import '../../../models/doctor/doctor.dart';
import '../../../screens/appointment/widgets/onboarding_loading.dart';
import '../../utils/show_error_snackbar.dart';
import '../buttons/primary_button.dart';
import '../inputs/doctor_search_bar.dart';
import '../list_tile/doctor_list_tile.dart';
import 'base/modal_base.dart';

Future<bool?> show_save_general_doctor_modal(BuildContext context) async {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Ajouter mon médecin traitant",
          child: _SaveGeneralDoctorWidget(),
        ),
      ];
    },
  );
}

class _SaveGeneralDoctorWidget extends StatefulWidget {
  const _SaveGeneralDoctorWidget();

  @override
  State<_SaveGeneralDoctorWidget> createState() => _SaveGeneralDoctorWidgetState();
}

class _SaveGeneralDoctorWidgetState extends State<_SaveGeneralDoctorWidget> {
  final GlobalKey<FormState> saveGeneralDoctorKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();
  final String _speciality = 'Généraliste';
  bool _isLoadingMore = false;
  String? _selectedDoctorId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorRecruitmentBloc, DoctorRecruitmentState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: _doctorRecruitmentListener,
      child: Form(
        key: saveGeneralDoctorKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  DoctorSearchBar(
                    onSearch: (value) {
                      _nameController.text = value;
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess(List<Doctor> doctors, bool isLoadingMore) {
    _isLoadingMore = isLoadingMore;

    if(_nameController.text.isEmpty) {
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

                }
              },
            ),
            onTap: () {
              setState(() {
                _selectedDoctorId = doctor.id;
              });
            },
          );
        }

        if (isLoadingMore && index == doctors.length) {
          return const Center(child: CircularProgressIndicator());
        }

        return const SizedBox.shrink();
      },
    );
  }


  void _saveGeneralDoctor() {
    //todo mélissa
  }

  void _loadingInitialDoctorSearch() {
    final displayDoctor = context.read<DisplayDoctorBloc>();
    displayDoctor.add(OnGetInitialSearchDoctor(
      name: _nameController.text,
      speciality: _speciality,
      languages: '',
      valid: false,
    ));
  }

  void _loadNextDoctorSearch() {
    final displayDoctor = context.read<DisplayDoctorBloc>();
    displayDoctor.add(OnGetNextSearchDoctor(
      name: _nameController.text,
      speciality: _speciality,
      languages: '',
      valid: false,
    ));
  }

  void _doctorRecruitmentListener(BuildContext context, DoctorRecruitmentState state) {
    // if (state.status == DoctorRecruitmentStatus.success) {
    //   Navigator.of(context).pop(true);
    // } else if (state.status == DoctorRecruitmentStatus.error) {
    //   showErrorSnackbar(context, state.exception);
    // }
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
}
