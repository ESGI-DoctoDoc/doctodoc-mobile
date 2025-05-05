import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

import 'base/input_text.dart';

class _FirstNameValidator extends Validator {
  final bool required;
  final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ'\- ]+$");

  _FirstNameValidator({
    this.required = true,
  });

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? "Le prénom est requis" : null;
    } else if (value.length <= 2 || value.length >= 16) {
      return "Le prénom est invalide";
    } else {
      return null;
    }
  }
}

class FirstnameInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;
  final Function? onChanged;

  const FirstnameInput({
    super.key,
    required this.controller,
    this.required = true,
    this.onChanged,
  });

  @override
  State<FirstnameInput> createState() => _FirstnameInputState();
}

class _FirstnameInputState extends State<FirstnameInput> {
  late final _FirstNameValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = _FirstNameValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: "Prénom",
      placeholder: "John",
      controller: widget.controller,
      validator: _validator.validation,
      onChange: widget.onChanged,
    );
  }
}
