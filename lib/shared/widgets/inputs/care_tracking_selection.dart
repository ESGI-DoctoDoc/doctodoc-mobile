import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_selection.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

class CareTrackingValidator extends Validator {
  final bool required;
  final String errorMessage = "Le suivi de dossier est requis";

  CareTrackingValidator({this.required = true});

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? errorMessage : null;
    } else {
      return null;
    }
  }
}

class CareTrackingItem extends InputSelectionItem {
  final String careTrackingId;
  final String careTrackingName;

  const CareTrackingItem({
    required this.careTrackingId,
    required this.careTrackingName,
  }) : super(label: careTrackingName, value: careTrackingId);
}

class CareTrackingSelection extends StatefulWidget {
  final TextEditingController controller;
  final List<CareTrackingItem> careTrackings; //todo add model
  final Function(InputSelectionItem item) onChange;
  final bool? required;

  const CareTrackingSelection({
    super.key,
    required this.controller,
    required this.careTrackings,
    required this.onChange,
    this.required = true,
  });

  @override
  State<CareTrackingSelection> createState() => _CareTrackingSelectionState();
}

class _CareTrackingSelectionState extends State<CareTrackingSelection> {
  late final CareTrackingValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = CareTrackingValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputSelection(
      controller: widget.controller,
      items: widget.careTrackings,
      onChange: widget.onChange,
      validator: _validator.validation,
    );
  }
}
