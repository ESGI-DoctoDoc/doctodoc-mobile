import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/base/list_tile_base.dart';
import 'package:flutter/material.dart';

import '../modals/document_menu_modal.dart';

class DocumentListTile extends StatelessWidget {
  final Document document;

  // final String title;
  final String? subtitle;
  final Widget? trailing;

  const DocumentListTile({
    super.key,
    required this.document,
    // required this.title,
    this.trailing,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileBase(
      title: document.name,
      subtitle: subtitle,
      leading: _buildLeadingIcon(context),
      trailing: trailing ??
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showDocumentMenuModal(context, document),
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
