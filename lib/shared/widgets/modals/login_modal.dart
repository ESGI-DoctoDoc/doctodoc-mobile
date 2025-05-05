import 'package:doctodoc_mobile/shared/widgets/modals/register_modal.dart';
import 'package:flutter/material.dart';

import '../buttons/primary_button.dart';
import '../inputs/email_input.dart';
import '../inputs/password_input.dart';
import 'base/modal_base.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final loginKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalBase(
      title: 'Connexion',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey, //todo utiliser theme
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/doctodoc-logo.png'),
            const SizedBox(height: 30),
            Form(
              key: loginKey,
              child: Column(
                children: [
                  EmailInput(controller: emailController),
                  const SizedBox(height: 10),
                  PasswordInput(controller: passwordController),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "Se connecter",
              onTap: () => _login(),
            ),
            FilledButton(onPressed: () => _fastLogin(), child: const Text('Fast login')),
            const SizedBox(height: 20),
            const Text("Mot de passe oublié ?"),
            const SizedBox(height: 10),
            InkWell(
              child: const Text("Toujours pas inscrit ? Inscrivez-vous"),
              onTap: () => showRegisterModal(context, true),
            ),
          ],
        ),
      ),
    );
  }

  void _fastLogin() {
    emailController.text = "m.laurant@mail.fr";
    passwordController.text = "mypassword";
  }

  void _login() {
    print("logging ...");
  }
}

void showLoginModal(BuildContext context, bool replace) {
  if (replace) {
    Navigator.pop(context);
  }
  Future.microtask(() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: LoginModal(),
          ),
        ),
      ));
}
