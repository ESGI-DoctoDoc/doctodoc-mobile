import 'package:flutter/material.dart';

import 'base/input_text.dart';

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
  // late final PasswordValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _validator = PasswordValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: "Mot de passe",
      placeholder: "**********",
      controller: widget.controller,
      type: InputTextType.password
      // validator: _validator.validation,
    );
  }
}
