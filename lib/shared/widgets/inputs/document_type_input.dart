import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_dropdown.dart';
import 'package:flutter/material.dart';

import '../../../models/document.dart';

class DocumentTypeItem extends InputDropdownItem {
  final String typeId;
  final String name;

  const DocumentTypeItem({
    required this.typeId,
    required this.name,
  }) : super(label: name, value: typeId);
}

class DocumentTypeInput extends StatefulWidget {
  final TextEditingController controller;

  const DocumentTypeInput({
    super.key,
    required this.controller,
  });

  @override
  State<DocumentTypeInput> createState() => _DocumentTypeInputState();
}

class _DocumentTypeInputState extends State<DocumentTypeInput> {
  final List<DocumentTypeItem> _documentTypes = DocumentType.values
      .map((value) => DocumentTypeItem(
            typeId: value.label,
            name: value.label,
          ))
      .toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InputDropdown(
      label: 'Type de document',
      placeholder: 'Sélectionnez un type de document',
      controller: widget.controller,
      items: _documentTypes,
    );
  }
}
