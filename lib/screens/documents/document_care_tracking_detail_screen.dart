import 'package:doctodoc_mobile/models/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../blocs/document/display_document_content_bloc/display_document_content_bloc.dart';

class DocumentCareTrackingDetailScreen extends StatefulWidget {
  static const String routeName = "/care-tracking/:careTrackingId/documents/:documentId";

  static void navigateTo(BuildContext context, String documentId, careTrackingId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentCareTrackingDetailScreen(
            documentId: documentId, careTrackingId: careTrackingId),
      ),
    );
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['documentId'] is String && arguments['careTrackingId'] is String) {
      return DocumentCareTrackingDetailScreen(
        documentId: arguments['documentId'],
        careTrackingId: arguments['careTrackingId'],
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text('Invalid document ID'),
        ),
      );
    }
  }

  final String documentId;
  final String careTrackingId;

  const DocumentCareTrackingDetailScreen({
    super.key,
    required this.documentId,
    required this.careTrackingId,
  });

  @override
  State<DocumentCareTrackingDetailScreen> createState() => _DocumentCareTrackingDetailScreenState();
}

class _DocumentCareTrackingDetailScreenState extends State<DocumentCareTrackingDetailScreen> {
  @override
  void initState() {
    super.initState();
    _getUrl();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayDocumentContentBloc, DisplayDocumentContentState>(
      builder: (context, state) {
        return switch (state.displayDocumentContentOfCareTrackingStatus) {
          DisplayDocumentContentOfCareTrackingStatus.initial ||
          DisplayDocumentContentOfCareTrackingStatus.loading =>
            const SizedBox.shrink(),
          DisplayDocumentContentOfCareTrackingStatus.success => _buildSuccess(state.document),
          DisplayDocumentContentOfCareTrackingStatus.error => _buildError(),
        };
      },
    );
  }

  Widget _buildSuccess(Document? document) {
    if (document == null) {
      return _buildError();
    } else {
      return Container(
        color: const Color(0xFFEFEFEF),
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: const Color(0xFFEFEFEF),
            appBar: AppBar(
              title: Text(document.name),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [],
            ),
            body: buildDocumentViewer(document.url),
          ),
        ),
      );
    }
  }

  Widget _buildError() {
    return const Scaffold(
      body: Center(
        child: Text("Une erreur s'est produite."),
      ),
    );
  }

  void _getUrl() {
    print(widget.careTrackingId);
    context.read<DisplayDocumentContentBloc>().add(OnGetContentOnCareTracking(
          careTrackingId: widget.careTrackingId,
          id: widget.documentId,
        ));
  }
}

Widget buildDocumentViewer(String url) {
  return Image.network(
    url,
    fit: BoxFit.contain,
    loadingBuilder: (context, child, progress) {
      if (progress == null) return child;
      return const Center(child: CircularProgressIndicator());
    },
    errorBuilder: (context, error, stackTrace) {
      return PDF(
        onError: (error) => Center(child: Text('Erreur : $error')),
        onPageError: (error, page) => Center(child: Text('Erreur à la page $page : $error')),
      ).fromUrl(
        url,
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text('Erreur : $error')),
      );
    },
  );
}
