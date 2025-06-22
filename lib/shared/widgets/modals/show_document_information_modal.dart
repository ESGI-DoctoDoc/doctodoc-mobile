import 'package:doctodoc_mobile/blocs/medical_record/display_document_detail_bloc/display_document_detail_bloc.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'base/modal_base.dart';

void showDocumentInformationModal(BuildContext context, String documentId) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          child: _DocumentInformationWidget(documentId: documentId),
        ),
      ];
    },
  );
}

class _DocumentInformationWidget extends StatefulWidget {
  final String documentId;

  const _DocumentInformationWidget({
    required this.documentId,
  });

  @override
  State<_DocumentInformationWidget> createState() => _DocumentInformationWidgetState();
}

class _DocumentInformationWidgetState extends State<_DocumentInformationWidget> {
  @override
  void initState() {
    super.initState();
    _onGetDocumentDetail();
  }

  void _onGetDocumentDetail() {
    context.read<DisplayDocumentDetailBloc>().add(OnGetDocumentDetail(id: widget.documentId));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<DisplayDocumentDetailBloc, DisplayDocumentDetailState>(
        builder: (context, state) {
          return switch (state) {
            DocumentDetailInitial() || DocumentDetailLoading() => const SizedBox.shrink(),
            DocumentDetailError() => _buildError(), // todo Corentin revoie le build error
            DocumentDetailLoaded() => _buildSuccess(state.document),
          };
          // return _onBuildSuccess();
        },
      ),
    );
  }

  Column _buildSuccess(DocumentDetailed document) {
    print(document.uploadedBy.firstName);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Nom du document',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: Text(document.document.name),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Type de document',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.category),
          title: Text(document.type),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Uploadé par',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text('${document.uploadedBy.firstName} ${document.uploadedBy.lastName}'),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Uploadé le',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: Text(Jiffy.parse(document.uploadedAt, pattern: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS")
              .format(pattern: "dd/MM/yyyy à HH:mm")),
          // title: Text(document.uploadedAt),
        ),
      ],
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }
}
