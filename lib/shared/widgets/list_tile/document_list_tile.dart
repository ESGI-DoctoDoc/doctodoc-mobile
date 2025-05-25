import 'package:doctodoc_mobile/shared/widgets/list_tile/base/list_tile_base.dart';
import 'package:flutter/material.dart';

import '../modals/document_menu_modal.dart';

class DocumentListTile extends StatelessWidget {
  final String title;

  const DocumentListTile({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileBase(
      title: title,
      leading: _buildLeadingIcon(context),
      trailing: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () => showDocumentMenuModal(context),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Icon(Icons.vaccines, color: Colors.blue.shade900),
    );
  }
}
