import 'package:doctodoc_mobile/screens/medicals/medical_screen.dart';
import 'package:doctodoc_mobile/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../screens/auth/otp_screen.dart';
import '../../screens/doctors/doctor_detail_screen.dart';
import '../../screens/doctors/doctor_search_screen.dart';
import '../../screens/not_found_screen/not_found_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/profile/patient_detail_screen.dart';
import '../../screens/profile/patients_screen.dart';

class DynamicRouterConfig {
  static final routes = {
    OtpScreen.routeName: (args) => const OtpScreen(),
    OnboardingScreen.routeName: (args) => const OnboardingScreen(),
    PatientsScreen.routeName: (args) => const PatientsScreen(),
    PatientDetailsScreen.routeName: (args) => PatientDetailsScreen.routeBuilder(args),
    ProfileDetailsScreen.routeName: (args) => ProfileDetailsScreen.routeBuilder(args),
    MedicalScreen.routeName: (args) => MedicalScreen.routeBuilder(args),
    DoctorSearchScreen.routeName: (args) => const DoctorSearchScreen(),
    DoctorDetailScreen.routeName: (args) => DoctorDetailScreen.routeBuilder(args),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeBuilder = routes[settings.name];
    final nextScreen = routeBuilder == null
        ? const NotFoundScreen()
        : routeBuilder(settings.arguments);

    return MaterialPageRoute(builder: (context) => nextScreen);
  }
}
