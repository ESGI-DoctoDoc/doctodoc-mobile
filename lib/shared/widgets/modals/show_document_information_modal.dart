import 'package:doctodoc_mobile/models/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/document/display_document_detail_bloc/display_document_detail_bloc.dart';
import 'base/modal_base.dart';

void showDocumentInformationModal(BuildContext context, String documentId) {
  if(Navigator.canPop(context)) {
    Navigator.pop(context);
  }
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
    Jiffy.setLocale('fr-FR');
  }

  void _onGetDocumentDetail() {
    context
        .read<DisplayDocumentDetailBloc>()
        .add(OnGetDocumentDetailInMedicalRecord(id: widget.documentId));
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
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text("Nom du document"),
          subtitle: Text(document.document.name),
        ),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text('Type de document'),
          subtitle: Text(document.type),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Uploadé par'),
          subtitle: Text('${document.uploadedBy.firstName} ${document.uploadedBy.lastName}'),
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Uploadé le'),
          subtitle: Text(
            Jiffy.parseFromDateTime(DateTime.parse(document.uploadedAt)).format(pattern: "dd/MM/yyyy à HH:mm"),
          ),
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
