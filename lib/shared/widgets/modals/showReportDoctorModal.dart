import 'package:doctodoc_mobile/shared/widgets/banners/info_banner.dart';
import 'package:doctodoc_mobile/shared/widgets/banners/warning_banner.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/secondary_button.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'base/modal_base.dart';

Future<String?> showReportDoctorModal(BuildContext context) async {
  final TextEditingController reasonController = TextEditingController();

  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Sélectionnez une raison",
          child: _ReasonSelectionWidget(controller: reasonController),
        ),
      ];
    },
  );
}

class _ReasonSelectionWidget extends StatefulWidget {
  final TextEditingController controller;

  const _ReasonSelectionWidget({required this.controller});

  @override
  State<_ReasonSelectionWidget> createState() => _ReasonSelectionWidgetState();
}

class _ReasonSelectionWidgetState extends State<_ReasonSelectionWidget> {
  final List<InputDropdownItem> reasons = [
    InputDropdownItem(label: "Comportement inapproprié", value: "inappropriate_behavior"),
    InputDropdownItem(label: "Motif de consultation inapproprié", value: "inappropriate_consultation_reason"),
    InputDropdownItem(label: "Questions déplacées ou non professionnelles", value: "unprofessional_questions"),
    InputDropdownItem(label: "Annulation fréquente sans raison valable", value: "frequent_cancellations"),
    InputDropdownItem(label: "Informations incorrectes sur le profil", value: "incorrect_profile_info"),
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const WarningBanner(
              title: 'Le signalement d’un professionnel de santé est une démarche sérieuse. Chaque signalement fait l’objet d’une vérification manuelle. Merci de ne le faire que si cela est réellement justifié.',
            ),
            const SizedBox(height: 20),
            InputDropdown(
              label: "Raison",
              placeholder: "Sélectionnez une raison",
              controller: widget.controller,
              items: reasons,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "Êtes vous sur de vouloir signaler ce médecin ?",
              onTap: () {
                if (widget.controller.text.isNotEmpty) {
                  Navigator.of(context).pop(widget.controller.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Veuillez sélectionner une raison"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: "Annuler",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
