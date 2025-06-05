import 'package:doctodoc_mobile/layout/main_layout.dart';
import 'package:doctodoc_mobile/screens/introduction_screen.dart';
import 'package:doctodoc_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:doctodoc_mobile/services/data_sources/local_auth_data_source/shared_preferences_auth_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../shared/utils/show_error_snackbar.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/inputs/otp_input.dart';

class OtpScreen extends StatefulWidget {
  static String routeName = '/auth/otp';
  static navigateTo(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OtpScreen(),
      ),
    );
  }

  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isLoading = false;
  bool canGoNext = false;
  String code = "";
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: _authListener,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.chevron_left_outlined, size: 35),
                onPressed: () => _logoutUser(context),
              ),
              title: const Text(
                "Vérification du compte",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Un code vous a été envoyé par SMS, saisissez-le ci-dessous.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  OtpInput(
                    controller: codeController,
                    onSubmit: (otpCode) {
                      setState(() {
                        code = otpCode;
                        canGoNext = otpCode.length == 6;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: PrimaryButton(
                  label: "Continuer",
                  isLoading: isLoading,
                  disabled: !canGoNext,
                  onTap: () => _validateCode(context, code),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) async {
    if (state.status == AuthStatus.secondFactorAuthenticationError) {
      showErrorSnackbar(context, state.exception);
    } else if (state.status == AuthStatus.authenticated) {
      final sharedPreferences = SharedPreferencesAuthDataSource();
      sharedPreferences.saveHasCompletedTwoFactorAuthentication(true);

      final hasOnboarded = await sharedPreferences.hasCompletedOnboarding();
      if(hasOnboarded) {
        MainLayout.navigateTo(context);
      } else {
        OnboardingScreen.navigateTo(context);
      }
    } else if (state.status == AuthStatus.loadingSecondFactorAuthentication) {
      print("loading");
    }
    setState(() {
      isLoading = false;
    });
  }

  void _validateCode(BuildContext context, String code) {
    setState(() {
      isLoading = true;
    });
    final authBloc = context.read<AuthBloc>();
    authBloc.add(OnSecondFactorAuthentication(doubleAuthCode: code));
  }

  void _logoutUser(BuildContext context) {
    final sharedPreferences = SharedPreferencesAuthDataSource();
    sharedPreferences.reset();
    IntroductionScreen.navigateTo(context);
  }
}
