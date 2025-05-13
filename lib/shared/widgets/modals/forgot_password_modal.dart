import 'package:doctodoc_mobile/shared/widgets/inputs/email_input.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../banners/info_banner.dart';
import '../buttons/primary_button.dart';

class ForgotPasswordModal extends StatefulWidget {
  const ForgotPasswordModal({super.key});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final forgotPasswordKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool isSubmitted = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Column(
            children: [
              ..._buildOnSubmitted(),
              Form(
                key: forgotPasswordKey,
                child: Column(
                  children: [
                    EmailInput(controller: emailController),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: "Réinitialiser mon mot de passe",
                disabled: isSubmitted,
                onTap: () => _forgotPassword(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOnSubmitted() {
    if (isSubmitted) {
      return [
        const InfoBanner(
          title: "Un email de réinitialisation a été envoyé",
        ),
        const SizedBox(height: 20),
      ];
    } else {
      return [const SizedBox.shrink()];
    }
  }

  void _forgotPassword() async {
    if (forgotPasswordKey.currentState?.validate() == false) {
      return;
    }
    print("Verification email sent to ${emailController.text}");
    //todo appel forgot password
    setState(() {
      isSubmitted = true;
    });
  }
}

void showForgotPasswordModal(BuildContext context) {
  Navigator.pop(context);

  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasSabGradient: false,
          hasTopBarLayer: false,
          pageTitle: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Mot de passe oublié ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isTopBarLayerAlwaysVisible: true,
          trailingNavBarWidget: IconButton(
            padding: const EdgeInsets.all(20),
            icon: const Icon(Icons.close),
            onPressed: Navigator.of(context).pop,
          ),
          child: const ForgotPasswordModal(),
        ),
      ];
    },
  );
}
