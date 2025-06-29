import 'package:doctodoc_mobile/blocs/medical_record/write_document_bloc/write_document_bloc.dart';
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

Future<Patient?> showUpdateDocumentModal(BuildContext context,
    String documentId,
    String name,
    String type,
) {
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

  const _UpdateDocumentWidget({
    required this.name,
    required this.documentId,
    required this.type,
  });

  @override
  State<_UpdateDocumentWidget> createState() => _UpdateDocumentWidgetState();
}

class _UpdateDocumentWidgetState extends State<_UpdateDocumentWidget> {
  final GlobalKey<FormState> updateEmailKey = GlobalKey<FormState>();

  // todo Corentin des erreurs remontent quand on tape dans le champ
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
    return BlocListener<WriteDocumentBloc, WriteDocumentState>(
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

  void _uploadDocumentBlocListener(BuildContext context, WriteDocumentState state) {
    if (state.updateStatus == UpdateDocumentStatus.success) {
      Navigator.pop(context);
    } else if (state.updateStatus == UpdateDocumentStatus.error) {
      showErrorSnackbar(context, 'Une erreur est survenue'); // todo handle error
    }
  }

  void _updateDocument() {
    if (updateEmailKey.currentState!.validate()) {
      context.read<WriteDocumentBloc>().add(
        OnUpdateDocument(
          id: widget.documentId,
          type: _typeController.text,
          filename: _nameController.text,
        ),
      );
    }
  }
}
