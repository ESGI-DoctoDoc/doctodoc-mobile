import 'package:doctodoc_mobile/shared/widgets/modals/show_document_information_modal.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'base/modal_base.dart';

void showDocumentMenuModal(BuildContext context) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          child: _DocumentMenuWidget(),
        ),
      ];
    },
  );
}

class _DocumentMenuWidget extends StatelessWidget {
  const _DocumentMenuWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          ListTile(
            title: const Text("Ouvrir le document"),
            leading: const Icon(Icons.open_in_new),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Afficher les détails"),
            leading: const Icon(Icons.info),
            onTap: () => showDocumentInformationModal(
              context,
              "documentId", //todo remplace par l'ID du document
            ),
          ),
          ListTile(
            title: Text(
              "Supprimer le document",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Confirmer la suppression"),
                  content: const Text("Voulez-vous vraiment supprimer ce document ?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Annuler
                      },
                      child: const Text("Annuler"),
                    ),
                    TextButton(
                      onPressed: () {
                        //todo ajouter la logique de suppression du document
                      },
                      child: const Text("Oui"),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
