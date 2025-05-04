import 'package:flutter/material.dart';

import 'base/input_text.dart';

class LastnameInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;

  const LastnameInput({
    super.key,
    required this.controller,
    this.required,
  });

  @override
  State<LastnameInput> createState() => _LastnameInputState();
}

class _LastnameInputState extends State<LastnameInput> {
  // late final EmailValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _validator = EmailValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: "Nom",
      placeholder: "Doe",
      controller: widget.controller,
      // validator: _validator.validation,
    );
  }
}
