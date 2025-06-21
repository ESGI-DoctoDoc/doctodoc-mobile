import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class DocumentDetailScreen extends StatefulWidget {
  static const String routeName = "/documents/:documentId";

  static void navigateTo(BuildContext context, String documentId) {
    Navigator.pushReplacement(context, MaterialPageRoute(
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
  Widget build(BuildContext context) {
    print(widget.documentId);
    final String url = "https://www.oecd.org/content/dam/oecd/en/topics/policy-sub-issues/health-system-performance/health-brochure.pdf"; // à remplacer dynamiquement
    return Container(
      color: const Color(0xFFEFEFEF),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          appBar: AppBar(
            title: const Text('Nom_du_document'),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [

            ],
          ),
          body: buildDocumentViewer(url),
        ),
      ),
    );
  }
}

Widget buildDocumentViewer(String url) {
  if (url.toLowerCase().endsWith(".pdf")) {
    return const PDF().fromUrl(
      url,
      placeholder: (progress) => Center(child: Text('$progress %')),
      errorWidget: (error) => Center(child: Text('Erreur : $error')),
    );
  } else {
    return Image.network(
      url,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Text("Erreur de chargement"));
      },
    );
  }
}
