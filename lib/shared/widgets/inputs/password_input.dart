import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

import 'base/input_text.dart';

class PasswordValidator extends Validator {
  final bool required;
  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@\-_#!*$]).{6,}$');
  final String errorMessage = "Contenir au moins 6 caractères, une majuscule, un chiffre et un caractère spécial (@, -, _, #, !, *)";

  PasswordValidator({this.required = true});

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? "Le mot de passe est requis" : null;
    }
    if (value.length < 6) {
      return "Doit contenir au moins 6 caractères";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Doit contenir au moins une majuscule";
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return "Doit contenir au moins un chiffre";
    }
    if (!RegExp(r'[@\-_#!*$]').hasMatch(value)) {
      return "Doit contenir (@, -, _, #, !, *)";
    }
    return null;
  }
}

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool? required;

  const PasswordInput({
    super.key,
    required this.controller,
    this.label = "Mot de passe",
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
      label: widget.label,
      placeholder: "**********",
      controller: widget.controller,
      type: InputTextType.password,
      validator: _validator.validation,
    );
  }
}
