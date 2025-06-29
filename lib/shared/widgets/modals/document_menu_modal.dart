import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/screens/documents/document_detail_screen.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/showDocumentLogsModal.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/show_document_information_modal.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/update_document_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/medical_record/write_document_bloc/write_document_bloc.dart';
import '../../utils/show_error_snackbar.dart';
import 'base/modal_base.dart';

void showDocumentMenuModal(BuildContext context, Document document) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          child: _DocumentMenuWidget(
            document: document,
          ),
        ),
      ];
    },
  );
}

class _DocumentMenuWidget extends StatelessWidget {
  final Document document;

  const _DocumentMenuWidget({
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<WriteDocumentBloc, WriteDocumentState>(
      listenWhen: (previous, current) {
        return previous.deleteStatus != current.deleteStatus;
      },
      listener: _deleteDocumentBlocListener,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            ListTile(
              title: const Text("Ouvrir le document"),
              leading: const Icon(Icons.open_in_new),
              onTap: () {
                DocumentDetailScreen.navigateTo(context, document.id);
              },
            ),
            ListTile(
              title: const Text('Modifier le document'),
              leading: const Icon(Icons.edit),
              onTap: () {
                showUpdateDocumentModal(
                  context,
                  document.id,
                  document.name,
                  document.type,
                );
              },
            ),
            ListTile(
              title: const Text("Afficher les détails"),
              leading: Icon(Icons.info),
              onTap: () => showDocumentInformationModal(
                context,
                document.id,
              ),
            ),
            ListTile(
              title: const Text("Voir l'historique"),
              leading: const Icon(Icons.history),
              onTap: () {
                showDocumentLogsModal(context, document.id);
              }
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
                          context.read<WriteDocumentBloc>().add(OnDeleteDocument(id: document.id));
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
      ),
    );
  }

  void _deleteDocumentBlocListener(BuildContext context, WriteDocumentState state) {
    if (state.deleteStatus == DeleteDocumentStatus.success) {
      Navigator.of(context).pop();
    } else if (state.deleteStatus == DeleteDocumentStatus.error) {
      showErrorSnackbar(context, 'Une erreur est survenue');
    }
  }
}
