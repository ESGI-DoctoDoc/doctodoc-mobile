import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

import 'base/input_text.dart';

class EmailOrPhoneValidator extends Validator {
  final bool required;
  final String errorMessage = "Le numéro de téléphone ou l'email est invalide";

 const EmailOrPhoneValidator({this.required = true});

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? "Le champ est requis" : null;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phone = value.replaceAll(' ', '');

    if (emailRegex.hasMatch(value) || phone.length == 10) {
      return null;
    }

    return errorMessage;
  }
}

class EmailOrPhoneInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool? required;

  const EmailOrPhoneInput({
    super.key,
    required this.controller,
    this.label = "Email ou Numéro de téléphone",
    this.required,
  });

  @override
  State<EmailOrPhoneInput> createState() => _EmailOrPhoneInputState();
}

class _EmailOrPhoneInputState extends State<EmailOrPhoneInput> {
  late final EmailOrPhoneValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = EmailOrPhoneValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: widget.label,
      placeholder: "Email ou Numéro de téléphone",
      controller: widget.controller,
      type: InputTextType.text,
      validator: _validator.validation,
    );
  }
}
