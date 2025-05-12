import 'package:doctodoc_mobile/blocs/register_bloc/register_bloc.dart';
import 'package:doctodoc_mobile/screens/home_screen.dart';
import 'package:doctodoc_mobile/screens/onboarding/steps/onboading_general_practitioner_step.dart';
import 'package:doctodoc_mobile/screens/onboarding/steps/onboarding_birth_date_step.dart';
import 'package:doctodoc_mobile/screens/onboarding/steps/onboarding_name_step.dart';
import 'package:jiffy/jiffy.dart';
import 'package:doctodoc_mobile/screens/onboarding/widgets/onboarding_app_bar.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/on-boarding';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final numberOfPages = 4;

  String code = "";
  int _currentStep = 1;
  bool canGoNext = false;

  final _userData = _UserData();

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
    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: (previous, current) {
        return previous.onBoardingStatus != current.onBoardingStatus;
      },
      listener: _onBoardingListener,
      child: Scaffold(
        appBar: OnboardingAppBar(step: _currentStep, numberOfPages: numberOfPages),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            OnboardingNameStep(
              onNext: (isValid, firstName, lastName) {
                _userData.firstName = firstName;
                _userData.lastName = lastName;
                setState(() {
                  canGoNext = isValid;
                });
              },
            ),
            OnboardingBirthDateStep(
              onNext: (isValid, birthDate) {
                _userData.birthDate = birthDate;
                setState(() {
                  canGoNext = isValid;
                });
              },
            ),
            OnboardingGeneralPractitionerStep(
              onFinished: (doctorId) {
                _userData.generalPractitioner = doctorId;
                canGoNext = true;
              },
              onSkip: () {
                _userData.generalPractitioner = "";
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    canGoNext = true;
                  });
                });
              },
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PrimaryButton(
            label: _currentStep == numberOfPages - 1 ? "Terminer" : "Continuer",
            disabled: !canGoNext,
            onTap: () {
              if (_currentStep == numberOfPages - 1) {
                _onBoardingDone(context);
              } else {
                _nextPage();
              }
            },
          ),
        ),
      ),
    );
  }

  void _onBoardingListener(BuildContext context, RegisterState state) {
    if (state.onBoardingStatus == OnBoardingStatus.onBoarded) {
      print('on boarded ok');
      HomeScreen.navigateTo(context);
    } else if (state.onBoardingStatus == OnBoardingStatus.loading) {
      print('loading');
    } else if (state.onBoardingStatus == OnBoardingStatus.error) {
      print(state.exception?.code);
    }
  }

  void _onBoardingDone(BuildContext context) {
    if(!_userData.isValid()) {
      print("Error : User data is not valid");
      return;
    }

    final birthDate = _userData.birthDate != null && _userData.birthDate!.isNotEmpty
        ? Jiffy.parse(_userData.birthDate!, pattern: 'dd/MM/yyyy').format(pattern: 'yyyy-MM-dd')
        : "";
    final registerBloc = context.read<RegisterBloc>();
    registerBloc.add(OnBoarding(
      firstName: _userData.firstName ?? "",
      lastName: _userData.lastName ?? "",
      birthdate: birthDate,
      referentDoctorId: _userData.generalPractitioner ?? "",
    ));
  }
}

class _UserData {
  String? firstName = "";
  String? lastName = "";
  String? birthDate = "";
  String? generalPractitioner = "";

  isValid() {
    return firstName != null && lastName != null && birthDate != null;
  }
}