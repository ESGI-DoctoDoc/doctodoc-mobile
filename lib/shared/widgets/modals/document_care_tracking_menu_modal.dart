import 'package:doctodoc_mobile/blocs/document/write_document_in_care_tracking_bloc/write_document_in_care_tracking_bloc.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/showDocumentCareTrackingInformationModal.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/showDocumentCareTrackingLogsModal.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/update_document_care_tracking_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../screens/documents/document_care_tracking_detail_screen.dart';
import '../../utils/show_error_snackbar.dart';
import 'base/modal_base.dart';

void showDocumentCareTrackingMenuModal(
    BuildContext context, Document document, String careTrackingId) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          child: _DocumentMenuWidget(
            document: document,
            careTrackingId: careTrackingId,
          ),
        ),
      ];
    },
  );
}

class _DocumentMenuWidget extends StatelessWidget {
  final Document document;
  final String careTrackingId;

  const _DocumentMenuWidget({
    required this.document,
    required this.careTrackingId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<WriteDocumentInCareTrackingBloc, WriteDocumentInCareTrackingState>(
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
                DocumentCareTrackingDetailScreen.navigateTo(context, document.id, careTrackingId);
              },
            ),
            ListTile(
              title: const Text('Modifier le document'),
              leading: const Icon(Icons.edit),
              onTap: () {
                showDocumentCareTrackingUpdateModal(
                  context,
                  document.id,
                  document.name,
                  document.type,
                  careTrackingId,
                );
              },
            ),
            ListTile(
              title: const Text("Afficher les détails"),
              leading: const Icon(Icons.info),
              onTap: () {
                showDocumentCareTrackingInformationModal(
                  context,
                  document.id,
                  careTrackingId,
                );
              },
            ),
            ListTile(
                title: const Text("Voir l'historique"),
                leading: const Icon(Icons.history),
                onTap: () {
                  showDocumentCareTrackingLogsModal(context, document.id, careTrackingId);
                }),
          ],
        ),
      ),
    );
  }

  void _deleteDocumentBlocListener(BuildContext context, WriteDocumentInCareTrackingState state) {
    if (state.deleteStatus == DeleteDocumentStatus.success) {
      Navigator.of(context).pop();
    } else if (state.deleteStatus == DeleteDocumentStatus.error) {
      showErrorSnackbar(context, state.exception);
    }
  }
}
