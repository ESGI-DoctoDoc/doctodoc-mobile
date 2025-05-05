import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_date.dart';
import 'package:flutter/material.dart';

class BirthdateInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;
  final void Function()? onChanged;

  const BirthdateInput({
    super.key,
    required this.controller,
    this.required,
    this.onChanged,
  });

  @override
  State<BirthdateInput> createState() => _BirthdateInputState();
}

class _BirthdateInputState extends State<BirthdateInput> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InputDate(
      controller: widget.controller,
      label: "Date de naissance",
      min: DateTime.now().subtract(const Duration(days: 365 * 100)),
      max: DateTime.now().subtract(const Duration(days: 365 * 18)),
      onChanged: () => widget.onChanged?.call(),
    );
  }
}
