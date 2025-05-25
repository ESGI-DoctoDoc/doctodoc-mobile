import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'base/modal_base.dart';

void showCareTrackingMenuModal(BuildContext context) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          child: _CareTrackingMenuWidget(),
        ),
      ];
    },
  );
}

class _CareTrackingMenuWidget extends StatelessWidget {
  const _CareTrackingMenuWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          ListTile(
            title: const Text("Voir le détail du suivi"),
            leading: const Icon(Icons.visibility),
            onTap: () {}
          ),
          ListTile(
            title: const Text("Ajouter un rendez-vous"),
            leading: const Icon(Icons.add),
            onTap: () {}
          ),
          ListTile(
            title: const Text('Ajouter un document'),
            leading: const Icon(Icons.attach_file),
            onTap: () {}
          ),
        ],
      ),
    );
  }
}
