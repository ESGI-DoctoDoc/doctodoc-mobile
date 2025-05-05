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

  // final UserData _userData = UserData();

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OnboardingAppBar(title: "title"),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          OtpWidget(
            onSubmit: () {
              _nextPage();
            },
          ),
          OnboardingNameStep(
              // onNext: (firstName, lastName) {
              //   _userData.firstName = firstName;
              //   _userData.lastName = lastName;
              //   _nextPage();
              // },
              ),
          OnboardingBirthDateStep(
              //   onNext: (birthDate) {
              //     _userData.birthDate = birthDate;
              //     _nextPage();
              //   },
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
          onTap: () => _nextPage(),
        ),
      ),
    );
  }
}
