import 'package:doctodoc_mobile/shared/widgets/inputs/password_input.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../buttons/primary_button.dart';
import 'base/modal_base.dart';

void showChangePasswordModal(BuildContext context) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Changer votre mot de passe",
          child: _ChangePasswordWidget(),
        ),
      ];
    },
  );
}

class _ChangePasswordWidget extends StatefulWidget {
  const _ChangePasswordWidget();

  @override
  State<_ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<_ChangePasswordWidget> {
  final GlobalKey<FormState> changePasswordKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: changePasswordKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                PasswordInput(controller: oldPasswordController),
                const SizedBox(height: 10),
                PasswordInput(controller: newPasswordController),
                const SizedBox(height: 10),
                PasswordInput(controller: confirmPasswordController),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: "Mettre à jour les informations",
                  onTap: () => _updatePatient(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updatePatient() {
    if (changePasswordKey.currentState!.validate()) {
      // Call the API to update the password
      // If success, close the modal
      Navigator.of(context).pop();
    }
  }
}
