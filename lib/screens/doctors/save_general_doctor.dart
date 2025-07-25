import 'package:doctodoc_mobile/blocs/referent_doctor_blocs/write_referent_doctor_bloc/write_referent_doctor_bloc.dart';
import 'package:doctodoc_mobile/shared/utils/show_error_snackbar.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/doctor_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/doctor_blocs/display_doctor_bloc/display_doctor_bloc.dart';
import '../../models/doctor/doctor.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/inputs/doctor_search_bar.dart';
import '../appointment/widgets/onboarding_loading.dart';

class SaveGeneralDoctor extends StatefulWidget {
  static const String routeName = '/save-general-doctor/:doctorId';

  static void navigateTo(BuildContext context, String? doctorId) {
    Navigator.pushNamed(context, routeName, arguments: {
      'doctorId': doctorId,
    });
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['doctorId'] is String?) {
      return SaveGeneralDoctor(doctorId: arguments['doctorId'] as String?);
    }
    return const Center(child: Text('Doctor not found'));
  }

  final String? doctorId;

  const SaveGeneralDoctor({super.key, this.doctorId});

  @override
  State<SaveGeneralDoctor> createState() => _SaveGeneralDoctorState();
}

class _SaveGeneralDoctorState extends State<SaveGeneralDoctor> {
  final GlobalKey<FormState> saveGeneralDoctorKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();
  final String _speciality = 'Généraliste';
  bool _isLoadingMore = false;
  String? _selectedDoctorId;

  @override
  void initState() {
    super.initState();
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
    return BlocListener<WriteReferentDoctorBloc, WriteReferentDoctorState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: _onWriteReferentDoctorListener,
      child: Container(
        padding: const EdgeInsets.only(top: 20.0),
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Mon médecin traitant'),
            ),
            body: Form(
              key: saveGeneralDoctorKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DoctorSearchBar(
                          onSearch: (value) {
                            _nameController.text = value;
                            _loadingInitialDoctorSearch();
                          },
                        ),
                        const SizedBox(height: 12.0),
                        const Text(
                          'Résultats',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        BlocBuilder<DisplayDoctorBloc, DisplayDoctorState>(
                          builder: (context, state) {
                            if (state.status == DisplayDoctorStatus.loading) {
                              return const OnboardingLoading();
                            } else if (state.status == DisplayDoctorStatus.success) {
                              return _buildSuccess(state.doctors, state.isLoadingMore);
                            } else if (state.status == DisplayDoctorStatus.error) {
                              return _buildError();
                            } else {
                              return _buildEmpty();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                label: 'Sauvegarder mon médecin traitant',
                onTap: () {
                  if (_selectedDoctorId != null) {
                    _saveGeneralDoctor(_selectedDoctorId!);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess(List<Doctor> doctors, bool isLoadingMore) {
    _isLoadingMore = isLoadingMore;

    if (_nameController.text.isEmpty) {
      return const Center(
        child: Column(
          children: [
            Text("Veuillez faire une recherche !"),
          ],
        ),
      );
    }

    if (doctors.isEmpty) {
      return const Center(
        child: Text("Aucun médecin trouvé."),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: doctors.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < doctors.length) {
            final doctor = doctors[index];
            if (doctor.id == widget.doctorId) {
              _selectedDoctorId = doctor.id;
            }
            return DoctorListTile(
              doctor: doctor,
              trailing: Radio<String>(
                value: doctor.id,
                groupValue: _selectedDoctorId,
                onChanged: (String? value) {
                  setState(() {
                    _selectedDoctorId = value;
                  });
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _saveGeneralDoctor(String selectedDoctorId) {
    context.read<WriteReferentDoctorBloc>().add(OnSetReferentDoctor(doctorId: selectedDoctorId));
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

  _onWriteReferentDoctorListener(BuildContext context, WriteReferentDoctorState state) {
    if (state.status == WriteReferentDoctorStatus.success) {
      Navigator.pop(context);
    } else if (state.status == WriteReferentDoctorStatus.loading) {
    } else if (state.status == WriteReferentDoctorStatus.error) {
      showErrorSnackbar(context, state.exception);
    }
  }
}
