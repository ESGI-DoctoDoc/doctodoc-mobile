import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_date.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

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
      min: Jiffy.now().subtract(years: 100).dateTime,
      max: Jiffy.now().subtract(years: 18).subtract(days: 5).dateTime,
      onChanged: () => widget.onChanged?.call(),
    );
  }
}
