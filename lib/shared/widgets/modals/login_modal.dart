import 'package:doctodoc_mobile/screens/auth/otp_screen.dart';
import 'package:doctodoc_mobile/shared/utils/show_error_snackbar.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/email_or_phone_input.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/forgot_password_modal.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/register_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../models/credentials.dart';
import '../../../services/data_sources/local_auth_data_source/shared_preferences_auth_data_source.dart';
import '../buttons/primary_button.dart';
import '../inputs/password_input.dart';
import '../texts/inline_text_link.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final loginKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: _authListener,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Form(
              key: loginKey,
              child: Column(
                children: [
                  EmailOrPhoneInput(controller: emailController),
                  const SizedBox(height: 10),
                  PasswordInput(controller: passwordController),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "Se connecter",
              isLoading: isLoading,
              onTap: () => _login(),
            ),
            const SizedBox(height: 20),
            InlineTextLink(
              text: "Mot de passe oublié ?",
              onTap: () {
                showForgotPasswordModal(context);
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Toujours pas inscrit ?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InlineTextLink(
                  text: "Inscrivez-vous",
                  onTap: () {
                    showRegisterModal(context, true);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _login() {
    // check if form is valid
    if (!loginKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    Credentials credentials = Credentials(
      username: emailController.text.contains('@')
          ? emailController.text
          : "+33${emailController.text.substring(1)}".replaceAll(" ", "").trim(),
      password: passwordController.text,
    );

    final authBloc = context.read<AuthBloc>();
    authBloc.add(OnFirstFactorAuthentication(credentials: credentials));
  }

  void _authListener(BuildContext context, AuthState state) async {
    if (state.status == AuthStatus.firstFactorAuthenticationError) {
      showErrorSnackbar(context, state.exception);
    } else if (state.status == AuthStatus.firstFactorAuthenticationValidate) {
      print("login successful");
      final sharedPreferences = SharedPreferencesAuthDataSource();
      sharedPreferences.saveHasCompletedTwoFactorAuthentication(false);
      OtpScreen.navigateTo(context);
    } else if (state.status == AuthStatus.loadingFirstFactorAuthentication) {
      print("loading");
    }
    setState(() {
      isLoading = false;
    });
  }
}

void showLoginModal(BuildContext context, bool replace) {
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
              "Connectez-vous à votre compte",
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
          child: const LoginModal(),
        ),
      ];
    },
  );
}
