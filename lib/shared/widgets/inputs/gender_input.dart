import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_choice.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

class GenderValidator extends Validator {
  final bool required;
  final RegExp genderRegex = RegExp(r"^(MALE|FEMALE)$");

  GenderValidator({
    this.required = true,
  });

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? "Le genre est requis" : null;
    } else if (!genderRegex.hasMatch(value)) {
      return "Le genre est invalide";
    } else {
      return null;
    }
  }
}

class GenderInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;
  final Function(InputChoiceItem) onChange;

  const GenderInput({
    super.key,
    required this.controller,
    required this.onChange,
    this.required = true,
  });

  @override
  State<GenderInput> createState() => _GenderInputState();
}

class _GenderInputState extends State<GenderInput> {
  final List<InputChoiceItem> items = const [
    InputChoiceItem(label: "Homme", value: "MALE"),
    InputChoiceItem(label: "Femme", value: "FEMALE"),
  ];
  late final GenderValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = GenderValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputChoice(
      controller: widget.controller,
      items: items,
      validator: _validator.validation,
      onChange: (widget.onChange),
    );
  }
}
