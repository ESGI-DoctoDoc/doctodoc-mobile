import 'package:doctodoc_mobile/blocs/user_blocs/write_user_bloc/write_user_bloc.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/password_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../utils/show_error_snackbar.dart';
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
          child: const _ChangePasswordWidget(),
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
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<WriteUserBloc, WriteUserState>(
      listenWhen: (previous, current) {
        return previous.changePasswordStatus != current.changePasswordStatus;
      },
      listener: _changePasswordListener,
      child: Form(
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
                  PasswordInput(label: "Nouveau mot de passe", controller: newPasswordController),
                  const SizedBox(height: 10),
                  PasswordInput(
                      label: "Confirmation du mot de passe", controller: confirmPasswordController),
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
      ),
    );
  }

  void _updatePatient() {
    if (changePasswordKey.currentState!.validate()) {
      if (newPasswordController.text != confirmPasswordController.text) {
        showErrorSnackbar(context, "Les mots de passe ne correspondent pas");
        return;
      }

      context.read<WriteUserBloc>().add(
            OnChangePassword(
              oldPassword: oldPasswordController.text,
              newPassword: newPasswordController.text,
            ),
          );
    }
  }

  void _changePasswordListener(BuildContext context, WriteUserState state) async {
    if (state.changePasswordStatus == ChangePasswordStatus.success) {
      Navigator.of(context).pop();
    } else if (state.changePasswordStatus == ChangePasswordStatus.error) {
      showErrorSnackbar(context, state.exception);
    }
  }
}
