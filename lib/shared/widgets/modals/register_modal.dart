import 'package:doctodoc_mobile/blocs/register_bloc/register_bloc.dart';
import 'package:doctodoc_mobile/shared/utils/show_error_snackbar.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/phone_input.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/login_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../buttons/primary_button.dart';
import '../inputs/email_input.dart';
import '../inputs/password_input.dart';
import '../texts/inline_text_link.dart';

class RegisterModal extends StatefulWidget {
  const RegisterModal({super.key});

  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  final registerKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: (previous, current) {
        return previous.registerStatus != current.registerStatus;
      },
      listener: _registerListener,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Form(
              key: registerKey,
              child: Column(
                children: [
                  EmailInput(controller: emailController),
                  const SizedBox(height: 10),
                  PasswordInput(controller: passwordController),
                  const SizedBox(height: 10),
                  PhoneInput(controller: phoneController),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "S'inscrire",
              isLoading: isLoading,
              onTap: () => _register(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Déja inscrit ?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InlineTextLink(
                  text: "Connectez-vous",
                  onTap: () {
                    showLoginModal(context, true);
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "En vous inscrivant, vous acceptez nos conditions d'utilisation et notre politique de confidentialité.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerListener(BuildContext context, RegisterState state) {
    if (state.registerStatus == RegisterStatus.registered) {
      showLoginModal(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Inscription réussie, veuillez vous connecter."),
          backgroundColor: Colors.green,
        ),
      );
    } else if (state.registerStatus == RegisterStatus.loading) {
    } else if (state.registerStatus == RegisterStatus.error) {
      showErrorSnackbar(context, state.exception);
    }
    setState(() {
      isLoading = false;
    });
  }

  void _register() {
    // check if the form is valid
    if (!registerKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    final phoneNumber = "+33${phoneController.text.substring(1)}".replaceAll(" ", "");

    final registerBloc = context.read<RegisterBloc>();
    registerBloc.add(OnRegister(
      email: emailController.text,
      password: passwordController.text,
      phoneNumber: phoneNumber,
    ));
  }
}

void showRegisterModal(BuildContext context, bool replace) {
  if (replace) {
    Navigator.pop(context);
  }
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
              "Inscrivez-vous à Doctodoc pour continuer",
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
          child: const RegisterModal(),
        ),
      ];
    },
  );
}
