import 'package:doctodoc_mobile/shared/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../buttons/primary_button.dart';
import '../inputs/language_input.dart';
import '../inputs/speciality_input.dart';
import 'base/modal_base.dart';

Future<Map<String, String>?> showFilterSearchModal(
  BuildContext context,
  Map<String, String>? filters,
) async {
  final result = await WoltModalSheet.show<Map<String, String>>(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Filtrer la recherche",
          child: _FilterSearchModal(filters: filters),
        ),
      ];
    },
  );
  return result ?? filters;
}

class _FilterSearchModal extends StatefulWidget {
  final Map<String, String>? filters;

  const _FilterSearchModal({this.filters});

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
  void initState() {
    super.initState();
    if (widget.filters != null) {
      _specialityController.text = widget.filters?['speciality'] ?? '';
      _languageController.text = widget.filters?['languages'] ?? '';
    }
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
                    'languages': _languageController.text,
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: "Réinitialiser les filtres",
              onTap: () {
                _specialityController.clear();
                _languageController.clear();
                Navigator.of(context).pop({
                  'speciality': '',
                  'languages': '',
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
