import 'package:doctodoc_mobile/screens/appointment/steps/appointment_step_care_tracking.dart';
import 'package:doctodoc_mobile/screens/appointment/steps/appointment_step_date.dart';
import 'package:doctodoc_mobile/screens/appointment/steps/appointment_step_doctor_questions.dart';
import 'package:doctodoc_mobile/screens/appointment/steps/appointment_step_medical_concern.dart';
import 'package:doctodoc_mobile/screens/appointment/steps/appointment_step_patient.dart';
import 'package:doctodoc_mobile/screens/appointment/types/appointment_flow_data.dart';
import 'package:doctodoc_mobile/screens/appointment/types/appointment_flow_doctor_data.dart';
import 'package:doctodoc_mobile/screens/appointment/types/appointment_flow_slot_data.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/appointment_confirm_modal.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/appointment_blocs/appointment_bloc/appointment_bloc.dart';
import '../../services/dtos/pre_appointment_answers.dart';
import 'widgets/appointment_app_bar.dart';

class AppointmentScreen extends StatefulWidget {
  static const String routeName = '/appointment';

  static void navigateTo(
    BuildContext context,
    AppointmentFlowDoctorData doctorData,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AppointmentScreen(doctorData: doctorData),
      ),
    );
  }

  const AppointmentScreen({
    super.key,
    required this.doctorData,
  });

  final AppointmentFlowDoctorData doctorData;

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final PageController _pageController = PageController();
  final List<GlobalKey<FormState>> forms = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final AppointmentFlowData _appointmentData = AppointmentFlowData();

  bool isLoading = false;
  bool canGoNext = false;

  @override
  void initState() {
    super.initState();
    _appointmentData.doctorData = widget.doctorData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFEFEF),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          appBar: AppointmentAppBar(
            firstname: widget.doctorData.firstName,
            lastname: widget.doctorData.lastName,
            avatarUrl: widget.doctorData.pictureUrl,
            onBack: () {
              if (_pageController.page != 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          body: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return AppointmentStepPatient(
                    formKey: forms[0],
                    onNext: (patient) {
                      _appointmentData.patientData = patient;
                    },
                  );
                case 1:
                  return AppointmentStepMedicalConcern(
                    doctorId: widget.doctorData.doctorId,
                    formKey: forms[1],
                    onNext: (medicalConcernId) {
                      setState(() {
                        _appointmentData.medicalConcernId = medicalConcernId;
                      });
                    },
                  );
                case 2:
                  return AppointmentStepDoctorQuestions(
                    key: UniqueKey(),
                    medicalConcernId: _appointmentData.medicalConcernId,
                    formKey: forms[2],
                    onEmpty: () {
                      _appointmentData.answers = [];
                    },
                    onNext: (answers) {
                      _appointmentData.answers = answers;
                    },
                  );
                case 3:
                  return AppointmentStepCareTracking(
                    patientId: _appointmentData.patientData!.patientId,
                    formKey: forms[3],
                    onEmpty: () {},
                    onNext: (careTrackingId) {
                      _appointmentData.careTrackingId = careTrackingId;
                    },
                  );
                case 4:
                  return AppointmentStepDate(
                    medicalConcernId: _appointmentData.medicalConcernId,
                    formKey: forms[4],
                    onNext: (AppointmentFlowSlotData slotData) {
                      _appointmentData.slotData = slotData;
                    },
                  );
                default:
                  return Container();
              }
            },
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE8E8E8),
                  width: 2,
                ),
              ),
            ),
            child: PrimaryButton(
                label: "Continuer",
                onTap: () {
                  handleNextPage();
                }),
          ),
        ),
      ),
    );
  }

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void handleNextPage() {
    final currentPage = _pageController.page?.round() ?? 0;

    final formKey = forms[currentPage];
    final formState = formKey.currentState;
    if (formState == null) {
      nextPage();
      return;
    }

    canGoNext = formState.validate();
    if (!canGoNext) {
      return;
    }

    final isLastPage = currentPage == forms.length - 1;
    if (isLastPage) {
      _onLockedAppointment();
      try {
        showAppointmentConfirmationModal(context, _appointmentData.toReview());
      } catch (e) {
        // print("Error showing confirmation modal: $e");
      }
    } else {
      nextPage();
    }
  }

  _onLockedAppointment() {
    final appointmentBloc = context.read<AppointmentBloc>();
    try {
      final appointmentData = _appointmentData.toReview();
      appointmentBloc.add(OnLockedAppointment(
        doctorId: appointmentData.doctorData.doctorId,
        patientId: appointmentData.patientData.patientId,
        medicalConcernId: appointmentData.medicalConcernId!,
        slotId: appointmentData.slotData.slotId,
        careTrackingId: appointmentData.careTrackingId,
        date: appointmentData.slotData.date,
        time: appointmentData.slotData.time,
        answers: appointmentData.answers.map(
          (answer) {
            return PreAppointmentAnswers(
              questionId: answer.questionId,
              answer: answer.answer,
            );
          },
        ).toList(),
      ));
    } catch (e) {
      // print("Error converting appointment data to review: $e");
      return;
    }
  }
}
