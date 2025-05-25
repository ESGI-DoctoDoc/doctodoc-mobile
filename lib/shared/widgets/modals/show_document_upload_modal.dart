import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:file_picker/file_picker.dart';

import '../../../screens/documents/add_document_screen.dart';
import 'base/modal_base.dart';

void showDocumentUploadModal(
  BuildContext context, {
  required Function onDocumentUploaded,
}) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          child: _DocumentUploadWidget(onDocumentUploaded: onDocumentUploaded),
        ),
      ];
    },
  );
}

class _DocumentUploadWidget extends StatelessWidget {
  final Function onDocumentUploaded;

  const _DocumentUploadWidget({required this.onDocumentUploaded});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Charger une photo"),
            leading: const Icon(Icons.photo_camera),
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                allowMultiple: false,
              );

              handleFileSelection(result, context);
            },
          ),
          ListTile(
            title: const Text("Charger un document"),
            leading: const Icon(Icons.upload_file),
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf', 'doc'],
              );

              handleFileSelection(result, context);
            },
          ),
        ],
      ),
    );
  }

  void handleFileSelection(FilePickerResult? result, BuildContext context) {
    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.single.path!);
      AddDocumentScreen.navigateTo(context, file);
    } else {
      print("No file selected or file selection was cancelled.");
    }
  }
}