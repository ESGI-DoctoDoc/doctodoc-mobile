import 'package:doctodoc_mobile/shared/widgets/banners/info_banner.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/firstname_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/lastname_input.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../buttons/primary_button.dart';
import 'base/modal_base.dart';

Future<bool?> showInviteDoctorModal(BuildContext context) async {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "On contacte votre médecin traitant",
          child: _InviteDoctorWidget(),
        ),
      ];
    },
  );
}

class _InviteDoctorWidget extends StatefulWidget {
  const _InviteDoctorWidget();

  @override
  State<_InviteDoctorWidget> createState() => _InviteDoctorWidgetState();
}

class _InviteDoctorWidgetState extends State<_InviteDoctorWidget> {
  final GlobalKey<FormState> inviteDoctorKey = GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: inviteDoctorKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                FirstnameInput(controller: _firstnameController),
                const SizedBox(height: 10),
                LastnameInput(controller: _lastnameController),
                const SizedBox(height: 10),
                InfoBanner(title: "Nous allons contacter votre médecin traitant pour l'inviter à rejoindre Doctodoc."),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: "Inviter mon médecin",
                  onTap: () => _inviteDoctor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _inviteDoctor() {
    if (inviteDoctorKey.currentState!.validate()) {
      // Call the API to invite the doctor
      // If success, close the modal
      Navigator.of(context).pop(true);
    }
  }
}
