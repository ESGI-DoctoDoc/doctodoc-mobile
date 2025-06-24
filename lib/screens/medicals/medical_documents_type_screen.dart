import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/medical_record/display_medical_record_documents_bloc/display_medical_record_documents_bloc.dart';
import '../../models/document.dart';
import '../../shared/widgets/list_tile/document_list_tile.dart';
import '../appointment/widgets/onboarding_loading.dart';

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
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
          _isLoadingMore) {
        _fetchNextDocuments();
      }
    });
    _fetchInitialDocuments();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFEFEF),
        title: Text(DocumentType.of(widget.documentType).label),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<DisplayMedicalRecordDocumentsBloc, DisplayMedicalRecordDocumentsState>(
          builder: (context, state) {
            return switch (state.status) {
              DisplayMedicalRecordDocumentsStatus.initial ||
              DisplayMedicalRecordDocumentsStatus.initialLoading =>
                const OnboardingLoading(),
              DisplayMedicalRecordDocumentsStatus.success ||
              DisplayMedicalRecordDocumentsStatus.loading =>
                _buildSuccess(state.documents, state.isLoadingMore),
              DisplayMedicalRecordDocumentsStatus.error => _buildError(),
            };
          },
        ),
      ),
    );
  }

  Widget _buildSuccess(List<Document> documents, bool isLoadingMore) {
    _isLoadingMore = isLoadingMore;
    return documents.isEmpty && isLoadingMore
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            padding: const EdgeInsets.all(0),
            controller: _scrollController,
            itemCount: documents.length + (isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index >= documents.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final document = documents[index];
        return DocumentListTile(
          document: document,
        );
      },
    );
  }

  void _fetchInitialDocuments() {
    if (mounted) {
      final bloc = context.read<DisplayMedicalRecordDocumentsBloc>();
      bloc.add(OnGetInitialMedicalRecordDocuments(
        type: DocumentType
            .of(widget.documentType)
            .label,
      ));
    }
  }

  void _fetchNextDocuments() {
    if (mounted) {
      final bloc = context.read<DisplayMedicalRecordDocumentsBloc>();
      bloc.add(OnGetNextMedicalRecordDocuments(
        type: DocumentType
            .of(widget.documentType)
            .label,
      ));
    }
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }
}
