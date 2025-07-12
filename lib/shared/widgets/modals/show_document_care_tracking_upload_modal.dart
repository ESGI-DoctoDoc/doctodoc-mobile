import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../screens/documents/add_document_care_tracking_screen.dart';
import 'base/modal_base.dart';

void showDocumentCareTrackingUploadModal(
  BuildContext context, {
  required String careTrackingId,
}) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          child: _DocumentUploadWidget(
            careTrackingId: careTrackingId,
          ),
        ),
      ];
    },
  );
}

class _DocumentUploadWidget extends StatelessWidget {
  final String careTrackingId;

  const _DocumentUploadWidget({
    required this.careTrackingId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Prendre une photo"),
            leading: const Icon(Icons.camera_alt),
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? photo = await picker.pickImage(source: ImageSource.camera);

              if (photo != null) {
                File file = File(photo.path);
                AddDocumentCareTrackingScreen.navigateTo(context, file, careTrackingId);
              } else {
              }
            },
          ),
          ListTile(
            title: const Text("Charger une photo"),
            leading: const Icon(Icons.image),
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
      AddDocumentCareTrackingScreen.navigateTo(context, file, careTrackingId);
    } else {
    }
  }
}
