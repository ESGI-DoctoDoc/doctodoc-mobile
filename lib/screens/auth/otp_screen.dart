import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth_bloc/auth_bloc.dart';
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
    print("Code validé : ${codeController.text}");
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

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
            onSubmit: (code) => _validateCode(context, code),
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
    } else if (state.status == AuthStatus.loadingSecondFactorAuthentication) {
      print("loading");
    }
  }

  void _validateCode(BuildContext context, String code) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(OnSecondFactorAuthentication(doubleAuthCode: code));
  }
}
