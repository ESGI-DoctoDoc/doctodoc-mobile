import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/shared/widgets/banners/info_banner.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/email_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/close_member_blocs/write_close_member_bloc/write_close_member_bloc.dart';
import '../buttons/primary_button.dart';
import 'base/modal_base.dart';

Future<Patient?> showUpdateEmailModal(
    BuildContext context,
    String email,
    ) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Modifier mon email",
          child: _UpdateEmailWidget(email: email),
        ),
      ];
    },
  );
}

class _UpdateEmailWidget extends StatefulWidget {
  final String email;

  const _UpdateEmailWidget({required this.email});

  @override
  State<_UpdateEmailWidget> createState() => _UpdateEmailWidgetState();
}

class _UpdateEmailWidgetState extends State<_UpdateEmailWidget> {
  final GlobalKey<FormState> updateEmailKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
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
                const InfoBanner(
                  title: "Vous devrez confirmer votre email pour valider la modification.",
                ),
                const SizedBox(height: 20),
                EmailInput(controller: emailController),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: "Mettre à jour mon email",
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
