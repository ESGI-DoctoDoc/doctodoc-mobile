import 'package:doctodoc_mobile/shared/widgets/list_tile/document_list_tile.dart';
import 'package:flutter/material.dart';

class DocumentsTab extends StatefulWidget {
  final ScrollController? scrollController;

  const DocumentsTab({super.key, this.scrollController});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  bool _isLoadingMore = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
    // _fetchInitialDocuments();
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController?.removeListener(_onScroll);
  }

  void _onScroll() {
    // if (widget.scrollController.position.pixels >= widget.scrollController.position.maxScrollExtent &&
    //     _isLoadingMore) {
    // _fetchMoreDocuments();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildSuccess([
            'Vaccin contre la grippe',
            'Ordonnance pour le diabète',
            'Résultats de la prise de sang',
            'Certificat médical pour le sport',
          ]),
        ),
      ]),
    );
  }

  Widget _buildSuccess(List<String> documents) {
    List<Widget> documentWidgets = documents.map((doc) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: DocumentListTile(title: doc),
      );
    }).toList();

    return Column(children: documentWidgets);
  }
}
