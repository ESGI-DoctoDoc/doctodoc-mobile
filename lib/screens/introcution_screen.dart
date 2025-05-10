import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:doctodoc_mobile/shared/widgets/texts/inline_text_link.dart';
import 'package:flutter/material.dart';

import '../shared/widgets/modals/login_modal.dart';
import '../shared/widgets/modals/register_modal.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/doctors.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                  right: 24.0, left: 24.0, bottom: 50, top: 24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(77),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/doctodoc-logo.png',
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Un suivi santé simple, rapide et sécurisé.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    label: "Se connecter",
                    onTap: () {
                      showLoginModal(context, false);
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Vous n'avez pas de compte ?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InlineTextLink(
                        text: "Inscrivez-vous",
                        onTap: () {
                          showRegisterModal(context, false);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
