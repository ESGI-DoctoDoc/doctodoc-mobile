import 'package:doctodoc_mobile/shared/widgets/inputs/phone_input.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/login_modal.dart';
import 'package:flutter/material.dart';

import '../buttons/primary_button.dart';
import '../inputs/email_input.dart';
import '../inputs/password_input.dart';
import 'base/modal_base.dart';

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

  @override
  Widget build(BuildContext context) {
    return ModalBase(
      title: 'Inscription',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.grey, //todo utiliser theme
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/doctodoc-logo.png'),
            const SizedBox(height: 30),
            Form(
              key: registerKey,
              child: Column(
                children: [
                  EmailInput(controller: emailController),
                  const SizedBox(height: 10),
                  PasswordInput(controller: passwordController),
                  const SizedBox(height: 10),
                  PhoneInput(controller: phoneController)
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "S'inscrire",
              onTap: () => _register(),
            ),
            FilledButton(onPressed: () => _fastRegister(), child: const Text('Fast register')),
            const SizedBox(height: 20),
            const Text("Mot de passe oublié ?"),
            const SizedBox(height: 10),
            InkWell(
              child: const Text("Toujours pas inscrit ? Inscrivez-vous"),
              onTap: () => showLoginModal(context, true),
            ),
          ],
        ),
      ),
    );
  }

  void _fastRegister() {
    emailController.text = "m.laurant@mail.fr";
    passwordController.text = "mypassword";
    phoneController.text = "0606060606";
  }
  //todo: mélissa job
  void _register() {
    print("Registering ...");
  }
}

void showRegisterModal(BuildContext context, bool replace) {
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
            child: RegisterModal(),
          ),
        ),
      ));
}
