import 'package:doctodoc_mobile/blocs/document/write_document_in_care_tracking_bloc/write_document_in_care_tracking_bloc.dart';
import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/document_name_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/document_type_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../utils/show_error_snackbar.dart';
import '../buttons/primary_button.dart';
import 'base/modal_base.dart';

class UpdateDocument {
  final String documentId;
  final String name;

  UpdateDocument({
    required this.documentId,
    required this.name,
  });
}

Future<Patient?> showDocumentCareTrackingUpdateModal(BuildContext context,
    String documentId,
    String name,
    String type,
    String careTrackingId,
) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Modifier le document",
          child: _UpdateDocumentWidget(
            name: name,
            documentId: documentId,
            type: type,
            careTrackingId: careTrackingId,
          ),
        ),
      ];
    },
  );
}

class _UpdateDocumentWidget extends StatefulWidget {
  final String documentId;
  final String name;
  final String type;
  final String careTrackingId;

  const _UpdateDocumentWidget({
    required this.name,
    required this.documentId,
    required this.type,
    required this.careTrackingId,
  });

  @override
  State<_UpdateDocumentWidget> createState() => _UpdateDocumentWidgetState();
}

class _UpdateDocumentWidgetState extends State<_UpdateDocumentWidget> {
  final GlobalKey<FormState> updateEmailKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _typeController.text = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WriteDocumentInCareTrackingBloc, WriteDocumentInCareTrackingState>(
      listenWhen: (previous, current) {
        return previous.updateStatus != current.updateStatus;
      },
      listener: _uploadDocumentBlocListener,
      child: Form(
        key: updateEmailKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  DocumentNameInput(controller: _nameController),
                  const SizedBox(height: 10),
                  DocumentTypeInput(controller: _typeController),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: "Mettre à jour le document",
                    onTap: () => _updateDocument(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _uploadDocumentBlocListener(BuildContext context, WriteDocumentInCareTrackingState state) {
    if (state.updateStatus == UpdateDocumentStatus.success) {
      Navigator.pop(context);
    } else if (state.updateStatus == UpdateDocumentStatus.error) {
      showErrorSnackbar(context, state.exception);
    }
  }

  void _updateDocument() {
    if (updateEmailKey.currentState!.validate()) {
      //todo mélissa care tracking
      context.read<WriteDocumentInCareTrackingBloc>().add(
            OnUpdateDocument(
              careTrackingId: widget.careTrackingId,
              id: widget.documentId,
              type: _typeController.text,
              filename: _nameController.text,
            ),
          );
    }
  }
}
