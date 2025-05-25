import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'base/modal_base.dart';

void showDocumentInformationModal(BuildContext context, String documentId) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          child: _DocumentInformationWidget(documentId: documentId),
        ),
      ];
    },
  );
}

class _DocumentInformationWidget extends StatelessWidget {
  final String documentId;
  final String documentName;
  final String documentType;
  final String uploadedBy;
  final String uploadedAt;

  const _DocumentInformationWidget({required this.documentId,
    this.documentName = 'Nom du document',
    this.documentType = 'Type de document',
    this.uploadedBy = 'Utilisateur',
    this.uploadedAt = 'Date de téléchargement',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Nom du document',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(documentName),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Type de document',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: Text(documentType),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Uploadé par',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Télécharger le document'),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Uploadé le',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(uploadedAt),
          ),
        ],
      ),
    );
  }
}
