import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_date.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';


class SelectDayValidator extends Validator {
  final bool required;
  final String errorMessage = "La date est invalide";

  SelectDayValidator({this.required = true});

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? "La date est requise" : null;
    }
    
    final date = Jiffy.parse(value, pattern: 'yyyy-MM-dd');
    final now = Jiffy.now();
    if (!date.isSameOrAfter(now, unit: Unit.day)) {
      return errorMessage;
    }

    return null;
  }
}

class SelectDayInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;

  const SelectDayInput({
    super.key,
    required this.controller,
    this.required,
  });

  @override
  State<SelectDayInput> createState() => _SelectDayInputState();
}

class _SelectDayInputState extends State<SelectDayInput> {
  late final SelectDayValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = SelectDayValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputDateNoModal(
      min: Jiffy.now().dateTime,
      max: Jiffy.now().clone().add(days: 60).dateTime,
      controller: widget.controller,
      validator: _validator.validation,
    );
  }
}
