import 'package:doctodoc_mobile/models/appointment/medical_concern_questions.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/appointment_label.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_selection.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_text.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/yes_no_input.dart';
import 'package:flutter/material.dart';

import 'base/input_choice.dart';

class DoctorQuestion {
  final MedicalConcernQuestionType type;
  final String questionId;
  final String question;
  final bool required;
  final List<InputSelectionItem> options;
  final Function(InputSelectionItem) onChange;

  DoctorQuestion({
    required this.type,
    required this.question,
    required this.questionId,
    required this.required,
    required this.onChange,
    this.options = const [],
  });
}

class DoctorQuestionInput extends StatefulWidget {
  final DoctorQuestion question;
  final TextEditingController controller;

  const DoctorQuestionInput({
    super.key,
    required this.controller,
    required this.question,
  });

  @override
  State<DoctorQuestionInput> createState() => _DoctorQuestionInputState();
}

class _DoctorQuestionInputState extends State<DoctorQuestionInput> {
  @override
  Widget build(BuildContext context) {
    return _buildInput();
  }

  Column _buildInput() {
    switch (widget.question.type) {
      case MedicalConcernQuestionType.list:
        return Column(
          children: [
            AppointmentLabel(
              label: widget.question.required
                  ? '${widget.question.question} *'
                  : widget.question.question,
            ),
            InputSelection(
              controller: widget.controller,
              items: widget.question.options,
              required: widget.question.required,
              onChange: (InputSelectionItem item) {
                widget.question.onChange(item);
              },
            ),
          ],
        );
      case MedicalConcernQuestionType.yesNo:
        return Column(
          children: [
            AppointmentLabel(
              label: widget.question.required
                  ? '${widget.question.question} *'
                  : widget.question.question,
            ),
            YesNoInput(
              controller: widget.controller,
              required: widget.question.required,
              onChange: (InputChoiceItem value) {
                widget.question.onChange(InputSelectionItem(
                  label: value.label,
                  value: value.value,
                ));
              },
            ),
          ],
        );
      case MedicalConcernQuestionType.text:
        return Column(
          children: [
            AppointmentLabel(
              label: widget.question.required
                  ? '${widget.question.question} *'
                  : widget.question.question,
            ),
            InputText(
              controller: widget.controller,
              label: "",
              placeholder: widget.question.question,
              required: widget.question.required,
              onChange: (String value) {
                widget.question.onChange(InputSelectionItem(
                  label: value,
                  value: value,
                ));
              },
            ),
          ],
        );
    }
  }
}
