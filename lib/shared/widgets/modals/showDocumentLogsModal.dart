import 'package:doctodoc_mobile/blocs/medical_record/display_document_historic_bloc/display_document_historic_bloc.dart';
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
    _onGetDocumentHistoric();
  }

  void _onGetDocumentHistoric() {
    context.read<DisplayDocumentHistoricBloc>().add(OnGetDocumentTraces(id: widget.documentId));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<DisplayDocumentHistoricBloc, DisplayDocumentHistoricState>(
        builder: (context, state) {
          return switch (state) {
            DocumentHistoricInitial() || DocumentHistoricLoading() => const SizedBox.shrink(),
            DocumentHistoricError() => _buildError(), // todo Corentin revoie le build error
            DocumentHistoricLoaded() => _buildSuccess(state.traces),
          };
          // return _onBuildSuccess();
        },
      ),
    );
  }

  Column _buildSuccess(List<DocumentTrace> traces) {
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
          itemCount: traces.length,
          itemBuilder: (context, index) {
            final trace = traces[index];
            final date = Jiffy.parse(trace.date, pattern: 'yyyy-MM-dd HH:mm')
                .format(pattern: 'd MMM yyyy à HH:mm');

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history),
              title: Text('${trace.type} - $date'),
              subtitle: Text(trace.description),
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
