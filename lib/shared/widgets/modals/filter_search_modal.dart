import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../buttons/primary_button.dart';
import '../inputs/language_input.dart';
import '../inputs/speciality_input.dart';
import 'base/modal_base.dart';



Future<Map<String, String>?> showFilterSearchModal(BuildContext context) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Filtrer la recherche",
          child: _FilterSearchModal(),
        ),
      ];
    },
  );
}

class _FilterSearchModal extends StatefulWidget {
  const _FilterSearchModal();

  @override
  State<_FilterSearchModal> createState() => _FilterSearchModalState();
}

class _FilterSearchModalState extends State<_FilterSearchModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _specialityController.dispose();
    _languageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SpecialityInput(controller: _specialityController, required: false),
            const SizedBox(height: 8.0),
            LanguageInput(controller: _languageController, required: false),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "Appliquer les filtres",
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop({
                    'speciality': _specialityController.text,
                    'language': _languageController.text,
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
