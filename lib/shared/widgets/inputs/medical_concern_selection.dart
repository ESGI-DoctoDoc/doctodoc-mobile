import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_selection.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

class MedicalConcernValidator extends Validator {
  final bool required;
  final String errorMessage = "Le motif de consultation est requis";

  MedicalConcernValidator({this.required = true});

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? errorMessage : null;
    } else {
      return null;
    }
  }
}

class MedicalConcernItem extends InputSelectionItem {
  final String medicalConcernId;
  final String name;

  const MedicalConcernItem({
    required this.medicalConcernId,
    required this.name,
  }) : super(label: name, value: medicalConcernId);
}

class MedicalConcernSelection extends StatefulWidget {
  final TextEditingController controller;
  final List<MedicalConcernItem> medicalConcerns; //todo add model
  final Function(InputSelectionItem item) onChange;
  final bool? required;

  const MedicalConcernSelection({
    super.key,
    required this.controller,
    required this.medicalConcerns,
    required this.onChange,
    this.required = true,
  });

  @override
  State<MedicalConcernSelection> createState() => _MedicalConcernSelectionState();
}

class _MedicalConcernSelectionState extends State<MedicalConcernSelection> {
  late final MedicalConcernValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = MedicalConcernValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputSelection(
      controller: widget.controller,
      items: widget.medicalConcerns,
      onChange: widget.onChange,
      validator: _validator.validation,
    );
  }
}
