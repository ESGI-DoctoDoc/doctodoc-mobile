import 'package:doctodoc_mobile/models/appointment/medical_concern_questions.dart';
import 'package:doctodoc_mobile/screens/appointment/types/appointment_flow_answer_data.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_selection.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/doctor_question_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/appointment_blocs/appointment_flow_bloc/appointment_flow_bloc.dart';
import '../widgets/appointment_label.dart';
import '../widgets/onboarding_loading.dart';

class AppointmentStepDoctorQuestions extends StatefulWidget {
  final String? medicalConcernId;
  final GlobalKey<FormState> formKey;
  final VoidCallback onEmpty;
  final Function(List<AppointmentFlowAnswerData>) onNext;

  const AppointmentStepDoctorQuestions({
    super.key,
    required this.formKey,
    required this.onEmpty,
    required this.onNext,
    this.medicalConcernId,
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
      _questions = [];
      _controllers = [];
    } else {
      _questions = questions
          .map(
            (question) => DoctorQuestion(
              type: question.type,
              question: question.question,
              questionId: question.id,
              required: question.required,
              options: question.options
                  .map((option) => InputSelectionItem(label: option, value: option))
                  .toList(),
              onChange: (InputSelectionItem item) {
                final answers = _questions.map((q) {
                  return AppointmentFlowAnswerData(
                    questionId: q.questionId,
                    answer: _controllers[_questions.indexOf(q)].text,
                  );
                }).toList();
                widget.onNext(answers);
              },
            ),
          )
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
    if (widget.medicalConcernId != null) {
      appointmentFlowBloc.add(GetQuestions(medicalConcernId: widget.medicalConcernId!));
    }
  }
}
