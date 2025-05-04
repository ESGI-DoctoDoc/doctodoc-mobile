import 'package:flutter/material.dart';

import 'base/input_text.dart';

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
  // late final EmailValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _validator = EmailValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: "Email",
      placeholder: "john.doe@mail.fr",
      controller: widget.controller,
      keyboardType: InputKeyboardType.email,
      // validator: _validator.validation,
    );
  }
}
