import 'package:doctodoc_mobile/screens/appointment/widgets/appointment_label.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_selection.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_text.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/yes_no_input.dart';
import 'package:flutter/material.dart';

enum DoctorQuestionType { list, yesNo, text }

class DoctorQuestion {
  final DoctorQuestionType type;
  final String question;
  final bool required;
  final List<InputSelectionItem> options;

  DoctorQuestion({
    required this.type,
    required this.question,
    required this.required,
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
      case DoctorQuestionType.list:
        return Column(
          children: [
            AppointmentLabel(label: widget.question.question),
            InputSelection(
              controller: widget.controller,
              items: widget.question.options,
              required: widget.question.required,
              onChange: (InputSelectionItem item) {},
            ),
          ],
        );
      case DoctorQuestionType.yesNo:
        return Column(
          children: [
            AppointmentLabel(label: widget.question.question),
            YesNoInput(controller: widget.controller, required: widget.question.required),
          ],
        );
      case DoctorQuestionType.text:
        return Column(
          children: [
            AppointmentLabel(label: widget.question.question),
            InputText(
              controller: widget.controller,
              label: "",
              placeholder: widget.question.question,
              required: widget.question.required,
            ),
          ],
        );
    }
  }
}
