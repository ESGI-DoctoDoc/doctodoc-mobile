import 'package:flutter/material.dart';

import 'base/input_text.dart';

class FirstnameInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;

  const FirstnameInput({
    super.key,
    required this.controller,
    this.required,
  });

  @override
  State<FirstnameInput> createState() => _FirstnameInputState();
}

class _FirstnameInputState extends State<FirstnameInput> {
  // late final EmailValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _validator = EmailValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: "Prénom",
      placeholder: "John",
      controller: widget.controller,
      // validator: _validator.validation,
    );
  }
}
