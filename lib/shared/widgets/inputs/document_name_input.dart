import 'package:doctodoc_mobile/shared/widgets/inputs/validators/validator.dart';
import 'package:flutter/material.dart';

import 'base/input_text.dart';

class _DocumentNameValidator extends Validator {
  final bool required;
  final nameRegex = RegExp(r"^[0-9\/a-zA-ZÀ-ÿ'\- ]+$");

  _DocumentNameValidator({
    this.required = true,
  });

  @override
  String? validation(String? value) {
    if (value == null || value.isEmpty) {
      return required ? "Le nom du document est requis" : null;
    } else if (value.length <= 2 || value.length >= 50) {
      return "Le nom du document est invalide";
    } else if (!nameRegex.hasMatch(value)) {
      return "Le nom du document contient des caractères invalides";
    } else {
      return null;
    }
  }
}

class DocumentNameInput extends StatefulWidget {
  final TextEditingController controller;

  const DocumentNameInput({
    super.key,
    required this.controller,
  });

  @override
  State<DocumentNameInput> createState() => _DocumentNameInputState();
}

class _DocumentNameInputState extends State<DocumentNameInput> {
  late final _DocumentNameValidator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = _DocumentNameValidator();
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: "Nom du document",
      placeholder: "Entrez le nom du document",
      controller: widget.controller,
      validator: _validator.validation,
    );
  }
}
