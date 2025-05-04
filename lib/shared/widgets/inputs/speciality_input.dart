import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_dropdown.dart';
import 'package:flutter/material.dart';

class SpecialityInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;

  const SpecialityInput({
    super.key,
    required this.controller,
    this.required,
  });

  @override
  State<SpecialityInput> createState() => _SpecialityInputState();
}

class _SpecialityInputState extends State<SpecialityInput> {
  final List<InputDropdownItem> specialityItems = [
    const InputDropdownItem(label: "Médecin Généraliste", value: "generaliste"),
    const InputDropdownItem(label: "Dentiste", value: "dentiste"),
    const InputDropdownItem(label: "Cardiologue", value: "cardiologue"),
    const InputDropdownItem(label: "Dermatologue", value: "dermatologue"),
    const InputDropdownItem(label: "Gynécologue", value: "gynecologue"),
    const InputDropdownItem(label: "Ophtalmologue", value: "ophtalmologue"),
    const InputDropdownItem(label: "Pédiatre", value: "pediatre"),
    const InputDropdownItem(label: "Psychiatre", value: "psychiatre"),
    const InputDropdownItem(label: "Orthophoniste", value: "orthophoniste"),
    const InputDropdownItem(label: "Kinésithérapeute", value: "kinesitherapeute"),
    const InputDropdownItem(label: "ORL (Oto-Rhino-Laryngologiste)", value: "orl"),
    const InputDropdownItem(label: "Chirurgien", value: "chirurgien"),
    const InputDropdownItem(label: "Rhumatologue", value: "rhumatologue"),
    const InputDropdownItem(label: "Urologue", value: "urologue"),
    const InputDropdownItem(label: "Endocrinologue", value: "endocrinologue"),
  ];

  @override
  Widget build(BuildContext context) {
    return InputDropdown(
      label: "Spécialité",
      placeholder: "Sélectionnez une spécialité",
      controller: widget.controller,
      items: specialityItems,
    );
  }
}
