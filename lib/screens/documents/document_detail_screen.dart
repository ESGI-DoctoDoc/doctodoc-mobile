import 'package:url_launcher/url_launcher.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../blocs/document/display_document_content_bloc/display_document_content_bloc.dart';

class DocumentDetailScreen extends StatefulWidget {
  static const String routeName = "/documents/:documentId";

  static void navigateTo(BuildContext context, String documentId) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentDetailScreen(documentId: documentId),
        ));
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['documentId'] is String) {
      return DocumentDetailScreen(documentId: arguments['documentId']);
    } else {
      return const Scaffold(
        body: Center(
          child: Text('Invalid document ID'),
        ),
      );
    }
  }

  final String documentId;

  const DocumentDetailScreen({super.key, required this.documentId});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  @override
  void initState() {
    super.initState();
    _getUrl();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayDocumentContentBloc, DisplayDocumentContentState>(
      builder: (context, state) {
        return switch (state.displayDocumentContentOfMedicalRecordStatus) {
          DisplayDocumentContentOfMedicalRecordStatus.initial ||
          DisplayDocumentContentOfMedicalRecordStatus.loading =>
            const SizedBox.shrink(),
          DisplayDocumentContentOfMedicalRecordStatus.success => _buildSuccess(state.document),
          DisplayDocumentContentOfMedicalRecordStatus.error => _buildError(),
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _downloadDocument(document),
                ),
              ],
            ),
            body: buildDocumentViewer(document.url),
          ),
        ),
      );
    }
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  void _getUrl() {
    context
        .read<DisplayDocumentContentBloc>()
        .add(OnGetContentOnMedicalRecord(id: widget.documentId));
  }

  void _downloadDocument(Document document) async {
    final url = document.url;
    final name = document.name;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible de télécharger le document.")),
      );
    }
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
