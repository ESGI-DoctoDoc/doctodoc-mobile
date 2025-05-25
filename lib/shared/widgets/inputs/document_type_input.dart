import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_dropdown.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_selection.dart';
import 'package:flutter/material.dart';

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
  late final List<DocumentTypeItem> _documentTypes;

  @override
  void initState() {
    super.initState();
    _documentTypes = [
      DocumentTypeItem(typeId: '1', name: 'Rapport médical'),
      DocumentTypeItem(typeId: '2', name: 'Ordonnance'),
      DocumentTypeItem(typeId: '3', name: 'Certificat médical'),
      DocumentTypeItem(typeId: '4', name: 'Résultats d\'analyses'),
      DocumentTypeItem(typeId: '5', name: 'Autre'),
    ];
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
