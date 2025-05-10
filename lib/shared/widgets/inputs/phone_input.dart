import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'base/input_text.dart';

class PhoneValidator extends Validator {
  final bool required;
  final String errorMessage = "Le numéro de téléphone est invalide";

  PhoneValidator({this.required = true});

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? "Le numéro de téléphone est requis" : null;
    } else if (value.length != 14) {
      return errorMessage;
    } else {
      return null;
    }
  }
}

class PhoneInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;

  const PhoneInput({
    super.key,
    required this.controller,
    this.required,
  });

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  final mask = MaskTextInputFormatter(
    mask: '#@ ## ## ## ##',
    filter: {"#": RegExp(r'[0-9]'), "@": RegExp(r'[67]')},
    type: MaskAutoCompletionType.lazy,
  );
  late final PhoneValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = PhoneValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: "Téléphone",
      placeholder: "## ## ## ## ##",
      controller: widget.controller,
      type: InputTextType.phone,
      mask: [mask],
      keyboardType: InputKeyboardType.numeric,
      validator: _validator.validation,
    );
  }
}
