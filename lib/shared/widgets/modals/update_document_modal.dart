import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/shared/widgets/banners/info_banner.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/document_name_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/email_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/close_member_blocs/write_close_member_bloc/write_close_member_bloc.dart';
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

Future<Patient?> showUpdateDocumentModal(
    BuildContext context,
    String documentId,
    String name,
    ) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Modifier le document",
          child: _UpdateDocumentWidget(name: name),
        ),
      ];
    },
  );
}

class _UpdateDocumentWidget extends StatefulWidget {
  final String name;

  const _UpdateDocumentWidget({required this.name});

  @override
  State<_UpdateDocumentWidget> createState() => _UpdateDocumentWidgetState();
}

class _UpdateDocumentWidgetState extends State<_UpdateDocumentWidget> {
  final GlobalKey<FormState> updateEmailKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: updateEmailKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                DocumentNameInput(controller: name),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: "Mettre à jour le document",
                  onTap: () => _updateEmail(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateEmail() {
    if (updateEmailKey.currentState!.validate()) {
      final writeCloseMemberBloc = context.read<WriteCloseMemberBloc>();
      // todo mélissa
      // writeCloseMemberBloc.add(OnUpdate(
      //   id: widget.patient.id,
      //   email: emailController.text,
      // ));

      Navigator.of(context).pop();
    }
  }
}
