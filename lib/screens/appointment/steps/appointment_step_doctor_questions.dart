import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_selection.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/doctor_question_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/gender_input.dart';
import 'package:flutter/material.dart';

import '../widgets/appointment_label.dart';
import '../widgets/onboarding_loading.dart';

class AppointmentStepDoctorQuestions extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onEmpty;

  const AppointmentStepDoctorQuestions({
    super.key,
    required this.formKey,
    required this.onEmpty,
  });

  @override
  State<AppointmentStepDoctorQuestions> createState() => _AppointmentStepDoctorQuestionsState();
}

class _AppointmentStepDoctorQuestionsState extends State<AppointmentStepDoctorQuestions> {
  late List<TextEditingController> _controllers;
  bool _isLoading = true;
  bool _hasError = false;
  List<DoctorQuestion> _questions = [
    DoctorQuestion(
      type: DoctorQuestionType.list,
      question: "Quel est votre sexe ?",
      required: true,
      options: const [
        InputSelectionItem(label: "Homme", value: "man"),
        InputSelectionItem(label: "Femme", value: "woman"),
      ],
    ),
    DoctorQuestion(
      type: DoctorQuestionType.yesNo,
      question: "Tu aimes ce design ?",
      required: true,
    ),
    DoctorQuestion(
      type: DoctorQuestionType.text,
      question: "La question qui fache !",
      required: true,
    ),
    DoctorQuestion(
      type: DoctorQuestionType.list,
      question: "Quel est votre sexe ?",
      required: false,
      options: const [
        InputSelectionItem(label: "Homme", value: "man"),
        InputSelectionItem(label: "Femme", value: "woman"),
      ],
    ),
    DoctorQuestion(
      type: DoctorQuestionType.yesNo,
      question: "Tu aimes ce design ?",
      required: false,
    ),
    DoctorQuestion(
      type: DoctorQuestionType.text,
      question: "La question qui fache !",
      required: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_questions.length, (_) => TextEditingController());
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        _isLoading = false;
      });
      if (_questions.isEmpty) {
        widget.onEmpty();
      }
    });
  }

  List<Widget> _buildQuestions() {
    if (_questions.isEmpty) {
      return const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppointmentLabel(label: "Aucune question demandée par le médecin."),
            Text("Vous pouvez passer cette étape."),
          ],
        ),
      ];
    } else {
      return List<Widget>.generate(_questions.length, (index) {
        return DoctorQuestionInput(
          question: _questions[index],
          controller: _controllers[index],
        );
      });
    }
  }

  Widget _buildSuccess() {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: _buildQuestions(),
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const OnboardingLoading();
    } else if (_hasError) {
      return _buildError();
    } else {
      return _buildSuccess();
    }
  }
}
