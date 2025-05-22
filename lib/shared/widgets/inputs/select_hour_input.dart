import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

import 'base/input_choice.dart';

class SelectHourValidator extends Validator {
  final bool required;
  final String errorMessage = "L'horaire est invalide";

  SelectHourValidator({this.required = true});

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? "L'horaire est requis" : null;
    }

    return null;
  }
}

class SelectHourItem extends InputChoiceItem {
  final String startTime;
  final String slotId;
  final bool isBooked;

  const SelectHourItem({
    required this.startTime,
    required this.slotId,
    this.isBooked = false,
  }) : super(label: startTime, value: slotId, disabled: isBooked);
}

class SelectHourInput extends StatefulWidget {
  final TextEditingController controller;
  final List<SelectHourItem> slots;

  const SelectHourInput({
    super.key,
    required this.controller,
    required this.slots,
  });

  @override
  State<SelectHourInput> createState() => _SelectHourInputState();
}

class _SelectHourInputState extends State<SelectHourInput> {
  final Validator _validator = SelectHourValidator(required: true);

  @override
  Widget build(BuildContext context) {
    return InputChoice(
      controller: widget.controller,
      validator: _validator.validation,
      items: widget.slots,
      maxPerRow: 3,
      onChange: (value) {},
    );
  }
}
