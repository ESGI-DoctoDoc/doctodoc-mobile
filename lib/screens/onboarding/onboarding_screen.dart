import 'package:doctodoc_mobile/screens/onboarding/steps/onboading_general_practitioner_step.dart';
import 'package:doctodoc_mobile/screens/onboarding/steps/onboarding_birth_date_step.dart';
import 'package:doctodoc_mobile/screens/onboarding/steps/onboarding_name_step.dart';
import 'package:doctodoc_mobile/screens/onboarding/widgets/onboarding_app_bar.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

import '../auth/otp_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  String code = "";
  int _currentStep = 1;
  bool canGoNext = false;

  final Map<String, String> _userData = {};

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    canGoNext = false;
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final int page =
          _pageController.hasClients && _pageController.page != null
              ? _pageController.page!.round()
              : 0;
      if (_currentStep != page + 1) {
        setState(() {
          _currentStep = page + 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OnboardingAppBar(
        title: "title",
        step: _currentStep,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          OtpWidget(
            onSubmit: (otpCode) {
              setState(() {
                canGoNext = otpCode.length == 6;
                code = otpCode;
              });
            },
          ),
          OnboardingNameStep(
            onNext: (isValid, firstName, lastName) {
              // _userData.firstName = firstName;
              // _userData.lastName = lastName;
              setState(() {
                canGoNext = isValid;
              });
            },
          ),
          OnboardingBirthDateStep(
            onNext: (isValid, birthDate) {
              // _userData.birthDate = birthDate;
              setState(() {
                canGoNext = isValid;
              });
            },
          ),
          OnboardingGeneralPractitionerStep(
              //   onFinish: (doctor) {
              //     _userData.generalPractitioner = doctor;
              //     // Finalisez l'onboarding ici
              //     print("Données utilisateur : $_userData");
              //   },
              ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PrimaryButton(
          label: "Continuer",
          disabled: !canGoNext,
          onTap: () => _nextPage(),
        ),
      ),
    );
  }
}
