import 'package:doctodoc_mobile/blocs/medical_record/display_document_detail_bloc/display_document_detail_bloc.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'base/modal_base.dart';

void showDocumentLogsModal(BuildContext context, String documentId) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          child: _DocumentLogsWidget(documentId: documentId),
        ),
      ];
    },
  );
}

class _DocumentLogsWidget extends StatefulWidget {
  final String documentId;

  const _DocumentLogsWidget({
    required this.documentId,
  });

  @override
  State<_DocumentLogsWidget> createState() => _DocumentLogsWidgetState();
}

class _DocumentLogsWidgetState extends State<_DocumentLogsWidget> {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historique des modifications',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            // final log = document.logs[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history),
              title: Text('nom.action'),
              subtitle: Text('valeur.action')
            );
          },
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
