import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

import 'base/input_text.dart';

class _LastNameValidator extends Validator {
  final bool required;
  final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ'\- ]+$");

  _LastNameValidator({
    this.required = true,
  });

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? "Le nom est requis" : null;
    } else if (value.length <= 2 || value.length >= 16) {
      return "Le nom est invalide";
    } else {
      return null;
    }
  }
}

class LastnameInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;
  final Function  ? onChanged;

  const LastnameInput({
    super.key,
    required this.controller,
    this.required = true,
    this.onChanged,
  });

  @override
  State<LastnameInput> createState() => _LastnameInputState();
}

class _LastnameInputState extends State<LastnameInput> {
  late final _LastNameValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = _LastNameValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: "Nom",
      placeholder: "Doe",
      controller: widget.controller,
      validator: _validator.validation,
      onChange: widget.onChanged,
    );
  }
}
