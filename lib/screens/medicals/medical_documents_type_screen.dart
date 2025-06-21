import 'package:flutter/material.dart';

class Document {
  final String id;
  final String title;
  final DateTime date;

  Document({
    required this.id,
    required this.title,
    required this.date,
  });
}

class MedicalDocumentsTypeScreen extends StatefulWidget {
  static const String routeName = '/patients/:patientId/medical/:type';

  static void navigateTo(BuildContext context, {required String patientId, required String type}) {
    Navigator.of(context).pushNamed(routeName, arguments: {
      'patientId': patientId,
      'type': type,
    });
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['patientId'] is String && arguments['type'] is String) {
      return MedicalDocumentsTypeScreen(
        patientId: arguments['patientId'] as String,
        documentType: arguments['type'] as String,
      );
    }
    return const Center(child: Text('Patient not found'));
  }

  final String documentType;
  final String patientId;

  const MedicalDocumentsTypeScreen({
    super.key,
    required this.documentType,
    required this.patientId,
  });

  @override
  State<MedicalDocumentsTypeScreen> createState() => _MedicalDocumentsTypeScreenState();
}

class _MedicalDocumentsTypeScreenState extends State<MedicalDocumentsTypeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Document> _documents = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialDocuments();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
          !_isLoading &&
          _hasMore) {
        _loadMoreDocuments();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialDocuments() async {
    setState(() {
      _isLoading = true;
    });

    final newDocs = await _fakeFetchDocuments(page: 0);
    setState(() {
      _documents.clear();
      _documents.addAll(newDocs);
      _currentPage = 1;
      _isLoading = false;
      _hasMore = newDocs.length == 10;
    });
  }

  Future<void> _loadMoreDocuments() async {
    setState(() {
      _isLoading = true;
    });

    final newDocs = await _fakeFetchDocuments(page: _currentPage);
    setState(() {
      _documents.addAll(newDocs);
      _currentPage += 1;
      _isLoading = false;
      _hasMore = newDocs.length == 10;
    });
  }

  Future<List<Document>> _fakeFetchDocuments({required int page}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (page > 3) return [];

    return List.generate(10, (index) {
      final number = page * 10 + index + 1;
      return Document(
        id: 'doc_$number',
        title: '${widget.documentType} #$number',
        date: DateTime.now().subtract(Duration(days: number)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFEFEF),
        title: Text(widget.documentType), //todo mélissa type de document formaté
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _documents.isEmpty && _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                controller: _scrollController,
                itemCount: _documents.length + (_isLoading ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index >= _documents.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final doc = _documents[index];
                  //todo mélissa nom du document
                  // return DocumentListTile(title: "name: ${doc.title}");
                  return Placeholder();
                },
              ),
      ),
    );
  }
}
