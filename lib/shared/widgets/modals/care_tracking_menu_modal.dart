import 'package:doctodoc_mobile/shared/widgets/modals/show_document_care_tracking_upload_modal.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../screens/care_tracking/care_tracking_detail_screen.dart';
import 'base/modal_base.dart';

void showCareTrackingMenuModal(BuildContext context, String careTrackingId) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          child: _CareTrackingMenuWidget(
            careTrackingId: careTrackingId,
          ),
        ),
      ];
    },
  );
}

class _CareTrackingMenuWidget extends StatelessWidget {
  final String careTrackingId;

  const _CareTrackingMenuWidget({
    required this.careTrackingId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          ListTile(
              title: const Text("Voir le détail du suivi"),
              leading: const Icon(Icons.visibility),
              onTap: () => CareTrackingDetailScreen.navigateTo(context, careTrackingId)),
          ListTile(
              title: const Text('Ajouter un document'),
              leading: const Icon(Icons.attach_file),
              onTap: () {
                showDocumentCareTrackingUploadModal(
                  context,
                  careTrackingId: careTrackingId,
                );
              }),
        ],
      ),
    );
  }
}
