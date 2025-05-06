import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_date.dart';
import 'package:flutter/material.dart';


class SelectDayInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;

  const SelectDayInput({
    super.key,
    required this.controller,
    this.required,
  });

  @override
  State<SelectDayInput> createState() => _SelectDayInputState();
}

class _SelectDayInputState extends State<SelectDayInput> {
  // late final EmailValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _validator = EmailValidator(required: widget.required ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return InputDateNoModal(
      controller: widget.controller,
      label: "Date de naissance",
    );
  }
}
