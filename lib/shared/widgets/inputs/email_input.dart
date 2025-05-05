import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

import 'base/input_text.dart';

class EmailValidator extends Validator {
  final bool required;
  final emailRegex =
  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final String errorMessage = "L'email est invalide";

  EmailValidator({this.required = true});

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? "L'email est requis" : null;
    } else if (!emailRegex.hasMatch(value)) {
      return errorMessage;
    } else {
      return null;
    }
  }
}

class EmailInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;

  const EmailInput({
    super.key,
    required this.controller,
    this.required,
  });

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  late final EmailValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = EmailValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: "Email",
      placeholder: "john.doe@mail.fr",
      controller: widget.controller,
      keyboardType: InputKeyboardType.email,
      validator: _validator.validation,
    );
  }
}
