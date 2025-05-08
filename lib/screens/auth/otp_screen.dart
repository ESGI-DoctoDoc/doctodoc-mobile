import 'package:doctodoc_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/inputs/otp_input.dart';

class OtpWidget extends StatefulWidget {
  static const String routeName = '/auth/opt';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  final Function(String code)? onSubmit;

  const OtpWidget({super.key, this.onSubmit});

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  final TextEditingController codeController = TextEditingController();

  void _submitCode() {
    if (widget.onSubmit != null) {
      widget.onSubmit!(codeController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Demander votre code de vérification"),
        const SizedBox(height: 20),
        OtpInput(
          controller: codeController,
          onSubmit: _submitCode,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool canGoNext = false;
  String code = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: _authListener,
      child: Scaffold(
        appBar: AppBar(title: const Text("Vérification du compte")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: OtpWidget(
            onSubmit: (otpCode) {
              setState(() {
                code = otpCode;
                canGoNext = otpCode.length == 6;
              });
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PrimaryButton(
            label: "Continuer",
            disabled: !canGoNext,
            onTap: () => _validateCode(context, code),
          ),
        ),
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.secondFactorAuthenticationError) {
      print(state.exception?.code);
    } else if (state.status == AuthStatus.authenticated) {
      print("login completed");
      // todo : check the onboarding status in shared preferences
      OnboardingScreen.navigateTo(context);
    } else if (state.status == AuthStatus.loadingSecondFactorAuthentication) {
      print("loading");
    }
  }

  void _validateCode(BuildContext context, String code) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(OnSecondFactorAuthentication(doubleAuthCode: code));
  }
}
