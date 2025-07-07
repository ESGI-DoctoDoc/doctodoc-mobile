import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/secondary_button.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'base/modal_base.dart';

Future<String?> showReasonSelectionModal(BuildContext context) async {
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
    InputDropdownItem(label: "Je ne suis plus disponible à ce créneau", value: "not_available"),
    InputDropdownItem(label: "J’ai obtenu un rendez-vous plus tôt ailleurs", value: "earlier_appointment_elsewhere"),
    InputDropdownItem(label: "Mon état de santé s’est amélioré", value: "health_improved"),
    InputDropdownItem(label: "Je veux reporter mon rendez-vous", value: "reschedule"),
    InputDropdownItem(label: "Je ne peux pas me déplacer", value: "cannot_travel"),
    InputDropdownItem(label: "Rendez-vous pris par erreur", value: "mistaken_booking"),
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            InputDropdown(
              label: "Raison",
              placeholder: "Sélectionnez une raison",
              controller: widget.controller,
              items: reasons,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "Confirmer l'annulation",
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
