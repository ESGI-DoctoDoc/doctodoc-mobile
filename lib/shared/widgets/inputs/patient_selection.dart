import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

import 'base/input_selection.dart';

class PatientValidator extends Validator {
  final bool required;
  final String errorMessage = "Le patient est requis";

  PatientValidator({this.required = true});

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? errorMessage : null;
    } else {
      return null;
    }
  }
}

class PatientItem extends InputSelectionItem {
  final String patientId;
  final String firstname;
  final String lastname;

  const PatientItem({
    required this.patientId,
    required this.firstname,
    required this.lastname,
  }) : super(label: "$firstname $lastname", value: patientId);
}


class PatientSelection extends StatefulWidget {
  final TextEditingController controller;
  final List<PatientItem> patients;
  final Function(PatientItem) onChange;
  final bool? required;

  const PatientSelection({
    super.key,
    required this.controller,
    required this.onChange,
    required this.patients,
    this.required = true,
  });

  @override
  State<PatientSelection> createState() => _PatientSelectionState();
}

class _PatientSelectionState extends State<PatientSelection> {
  late final PatientValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = PatientValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputSelection(
      controller: widget.controller,
      validator: _validator.validation,
      items: widget.patients,
      onChange: (InputSelectionItem item) {
        final selectedPatient = widget.patients.firstWhere((patient) => patient.patientId == item.value);
        widget.onChange(selectedPatient);
      },
    );
  }
}
