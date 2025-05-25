import 'dart:io';

import 'package:doctodoc_mobile/shared/widgets/inputs/document_name_input.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/inputs/document_type_input.dart';

class AddDocumentScreen extends StatefulWidget {
  final File file;

  static const String routeName = '/documents/add';

  static void navigateTo(BuildContext context, File file) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddDocumentScreen(file: file),
      ),
    );
  }

  const AddDocumentScreen({super.key, required this.file});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final addDocumentFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEFEFEF),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Color(0xFFEFEFEF),
          body: CustomScrollView(slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor,
              floating: true,
              snap: true,
              pinned: true,
              automaticallyImplyLeading: false,
              expandedHeight: 100.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(
                        child: const Icon(Icons.chevron_left),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Text(
                      'Ajouter un document',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                background: Container(
                  color: Color(0xFFEFEFEF),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Form(
                  key: addDocumentFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DocumentNameInput(controller: _nameController),
                        const SizedBox(height: 10),
                        DocumentTypeInput(controller: _typeController),
                        const SizedBox(height: 10),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Fichier',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),

                        // Display the selected file if image or document
                        _buildFilePreview(),
                      ],
                    ),
                  ),
                ),
              ]),
            )
          ]),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: PrimaryButton(
              label: "Uploader le document",
              onTap: () {
                //todo handle file upload
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreview() {
    print('Building file preview for: ${widget.file.path}');
    final String fileName = widget.file.path.split('/').last;
    final bool isPdf = widget.file.path.toLowerCase().endsWith('.pdf');
    final bool isImage =
        ['jpg', 'jpeg', 'png', 'heic'].any((ext) => widget.file.path.toLowerCase().endsWith('.$ext'));

    if(isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.file(
          widget.file,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline.withAlpha(50), width: 1.60),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPdf)
            Column(
              children: [
                const Icon(Icons.picture_as_pdf, size: 45, color: Colors.red),
                const SizedBox(height: 12),
                Text(fileName, style: const TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            )
          else
            const Column(
              children: const [
                Icon(Icons.insert_drive_file, size: 60),
                SizedBox(height: 8),
                Text('Preview non supporté', style: TextStyle(fontSize: 16)),
              ],
            ),
        ],
      ),
    );
  }
}
