import 'package:doctodoc_mobile/blocs/medical_record/display_medical_record_documents_bloc/display_medical_record_documents_bloc.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/document_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    _fetchDocuments();
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
          child: BlocBuilder<DisplayMedicalRecordDocumentsBloc, DisplayMedicalRecordDocumentsState>(
            builder: (context, state) {
              return switch (state.status) {
                DisplayMedicalRecordDocumentsStatus.initial ||
                DisplayMedicalRecordDocumentsStatus.loading =>
                  const OnboardingLoading(),
                DisplayMedicalRecordDocumentsStatus.success => _buildSuccess(state.documents),
                DisplayMedicalRecordDocumentsStatus.error => _buildError(),
              };
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildSuccess(List<Document> documents) {
    // List<String> names = documents.map((document) => document.name).toList();

    List<Widget> documentWidgets = documents.map((document) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: DocumentListTile(document: document),
      );
    }).toList();

    return Column(children: documentWidgets);
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  void _fetchDocuments() {
    context.read<DisplayMedicalRecordDocumentsBloc>().add(OnGetMedicalRecordDocuments());
  }
}
