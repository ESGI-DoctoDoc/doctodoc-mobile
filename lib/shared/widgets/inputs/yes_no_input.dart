import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_choice.dart';
import 'package:flutter/material.dart';

class YesNoInput extends StatelessWidget {
  final TextEditingController controller;
  final List<InputChoiceItem> items = const [
    InputChoiceItem(label: "Oui", value: "yes"),
    InputChoiceItem(label: "Non", value: "no"),
  ];
  final bool? required;

  const YesNoInput({
    super.key,
    required this.controller,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return InputChoice(
      controller: controller,
      items: items,
      required: required,
      onChange: (value) {},
    );
  }
}
