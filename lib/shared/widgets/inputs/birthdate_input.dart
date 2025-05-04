import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_date.dart';
import 'package:flutter/material.dart';

import 'base/input_text.dart';

class BirthdateInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;

  const BirthdateInput({
    super.key,
    required this.controller,
    this.required,
  });

  @override
  State<BirthdateInput> createState() => _BirthdateInputState();
}

class _BirthdateInputState extends State<BirthdateInput> {
  // late final EmailValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _validator = EmailValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputDate(
      controller: widget.controller,
      label: "Date de naissance",
    );
  }
}
