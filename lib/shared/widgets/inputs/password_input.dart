import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

import 'base/input_text.dart';

class PasswordValidator extends Validator {
  final bool required;
  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@\-_#$]).{6,}$');
  final String errorMessage = "Le mot de passe est invalide";

  PasswordValidator({this.required = true});

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? "Le mot de passe est requis" : null;
    } else if (!passwordRegex.hasMatch(value)) {
      return errorMessage;
    } else {
      return null;
    }
  }
}

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;

  const PasswordInput({
    super.key,
    required this.controller,
    this.required,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  late final PasswordValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = PasswordValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: "Mot de passe",
      placeholder: "**********",
      controller: widget.controller,
      type: InputTextType.password,
      validator: _validator.validation,
    );
  }
}
