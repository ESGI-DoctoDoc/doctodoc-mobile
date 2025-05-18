import 'package:doctodoc_mobile/screens/appointment/steps/appointment_step_care_tracking.dart';
import 'package:doctodoc_mobile/screens/appointment/steps/appointment_step_date.dart';
import 'package:doctodoc_mobile/screens/appointment/steps/appointment_step_doctor_questions.dart';
import 'package:doctodoc_mobile/screens/appointment/steps/appointment_step_medical_concern.dart';
import 'package:doctodoc_mobile/screens/appointment/steps/appointment_step_patient.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/appointment_confirm_modal.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/patient.dart';
import '../../shared/widgets/inputs/patient_selection.dart';
import 'widgets/appointment_app_bar.dart';

class AppointmentScreen extends StatefulWidget {
  static const String routeName = '/appointment';

  static void navigateTo(
    BuildContext context, {
    required String doctorId,
    required String doctorFirstName,
    required String doctorLastName,
    required String doctorPictureUrl,
    required double latitude,
    required double longitude,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AppointmentScreen(
          doctorId: doctorId,
          doctorFirstName: doctorFirstName,
          doctorLastName: doctorLastName,
          doctorPictureUrl: doctorPictureUrl,
          latitude: latitude,
          longitude: longitude,
        ),
      ),
    );
  }

  const AppointmentScreen({
    super.key,
    required this.doctorId,
    required this.doctorFirstName,
    required this.doctorLastName,
    required this.doctorPictureUrl,
    required this.latitude,
    required this.longitude,
  });

  final String doctorId;
  final String doctorFirstName;
  final String doctorLastName;
  final String doctorPictureUrl;
  final double latitude;
  final double longitude;

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

  final AppointmentData _appointmentData = AppointmentData();

  bool isLoading = false;
  bool canGoNext = false;

  @override
  void initState() {
    super.initState();
    _appointmentData.doctorId = widget.doctorId;
    _appointmentData.doctorPictureUrl = widget.doctorPictureUrl;
    _appointmentData.doctorFirstName = widget.doctorFirstName;
    _appointmentData.doctorLastName = widget.doctorLastName;
    _appointmentData.latitude = widget.latitude;
    _appointmentData.longitude = widget.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEFEFEF),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Color(0xFFEFEFEF),
          appBar: AppointmentAppBar(
            firstname: widget.doctorFirstName,
            lastname: widget.doctorLastName,
            avatarUrl: widget.doctorPictureUrl,
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
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              AppointmentStepPatient(
                formKey: forms[0],
                onNext: (PatientItem patient) {
                  _appointmentData.patientId = patient.patientId;
                },
              ),
              AppointmentStepMedicalConcern(
                formKey: forms[1],
                onNext: (String concern) {
                  _appointmentData.consultationConcern = concern;
                },
              ),
              AppointmentStepDoctorQuestions(
                formKey: forms[2],
                onEmpty: () {
                  // handleNextPage();
                },
              ),
              AppointmentStepCareTracking(
                formKey: forms[3],
                onEmpty: () {
                  // handleNextPage();
                },
                onNext: (String careTrackingId) {
                  _appointmentData.careTrackingId = careTrackingId;
                },
              ),
              AppointmentStepDate(
                formKey: forms[4],
              ),
            ],
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
              }
            ),
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
    if(formState == null) {
      nextPage();
      return;
    }

    canGoNext = formState.validate();
    if(!canGoNext) {
      print("Form is not valid");
      return;
    }

    final isLastPage = currentPage == forms.length - 1;
    if (isLastPage) {
      _appointmentData.date = DateTime.now();
      _appointmentData.time = "10:00";
      _appointmentData.consultationConcern = "Consultation concern";
      _appointmentData.patientId = "patientId";
      _appointmentData.careTrackingId = "careTrackingId";
      _appointmentData.questions = [
        Question()..questionName = "Question 1",
        Question()..questionName = "Question 2",
      ];

      showAppointmentConfirmationModal(context, _appointmentData);
    } else {
      nextPage();
    }
  }
}

class Question {
  String? questionName;
  String? answer;
}

class AppointmentData {
  String doctorId = '';
  String doctorPictureUrl = '';
  String doctorFirstName = '';
  String doctorLastName = '';
  double latitude = 0.0;
  double longitude = 0.0;
  DateTime? date;
  String? time;
  String? consultationConcern;
  String? patientId;
  List<Question> questions = [];
  String? careTrackingId;
}
