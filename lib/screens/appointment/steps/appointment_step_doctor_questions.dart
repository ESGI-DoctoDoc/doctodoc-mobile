import 'package:doctodoc_mobile/models/appointment/medical_concern_questions.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_selection.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/doctor_question_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/appointment_flow_bloc/appointment_flow_bloc.dart';
import '../widgets/appointment_label.dart';
import '../widgets/onboarding_loading.dart';

class AppointmentStepDoctorQuestions extends StatefulWidget {
  final String medicalConcernId;
  final GlobalKey<FormState> formKey;
  final VoidCallback onEmpty;

  const AppointmentStepDoctorQuestions({
    super.key,
    required this.medicalConcernId,
    required this.formKey,
    required this.onEmpty,
  });

  @override
  State<AppointmentStepDoctorQuestions> createState() => _AppointmentStepDoctorQuestionsState();
}

class _AppointmentStepDoctorQuestionsState extends State<AppointmentStepDoctorQuestions> {
  late List<TextEditingController> _controllers;
  List<DoctorQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_questions.length, (_) => TextEditingController());
    _fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentFlowBloc, AppointmentFlowState>(
      builder: (context, state) {
        return switch (state.getQuestionStatus) {
          GetQuestionStatus.initial || GetQuestionStatus.loading => const OnboardingLoading(),
          GetQuestionStatus.success => _buildSuccess(state.questions),
          GetQuestionStatus.error => _buildError(),
        };
      },
    );
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

  Widget _buildSuccess(List<MedicalConcernQuestion> questions) {
    if (questions.isEmpty) {
      widget.onEmpty;
    } else {
      _questions = questions
          .map((question) => DoctorQuestion(
              type: question.type,
              question: question.question,
              required: question.required,
              options: question.options
                  .map((option) => InputSelectionItem(label: option, value: option))
                  .toList()))
          .toList();

      _controllers = List.generate(_questions.length, (_) => TextEditingController());
    }

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

  void _fetchQuestions() {
    final appointmentFlowBloc = context.read<AppointmentFlowBloc>();
    appointmentFlowBloc.add(GetQuestions(medicalConcernId: widget.medicalConcernId));
  }
}
