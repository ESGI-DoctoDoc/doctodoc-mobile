import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_dropdown.dart';
import 'package:flutter/material.dart';

class LanguageInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;

  const LanguageInput({
    super.key,
    required this.controller,
    this.required,
  });

  @override
  State<LanguageInput> createState() => _LanguageInputState();
}

class _LanguageInputState extends State<LanguageInput> {
  final List<InputDropdownItem> languageItems = [
    const InputDropdownItem(icon: Icons.add, label: "Français", value: "french"),
    const InputDropdownItem(icon: Icons.add, label: "Anglais", value: "english"),
    const InputDropdownItem(icon: Icons.add, label: "Espagnol", value: "spanish"),
  ];

  @override
  Widget build(BuildContext context) {
    return InputDropdown(
      label: "Langues",
      placeholder: "Sélectionnez une langue",
      controller: widget.controller,
      items: languageItems,
    );
  }
}
