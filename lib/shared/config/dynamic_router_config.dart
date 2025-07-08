import 'package:doctodoc_mobile/screens/appointments/appointment_detail_screen.dart';
import 'package:doctodoc_mobile/screens/appointments/care_tracking_permissions_screen.dart';
import 'package:doctodoc_mobile/screens/doctors/save_general_doctor.dart';
import 'package:doctodoc_mobile/screens/documents/document_care_tracking_detail_screen.dart';
import 'package:doctodoc_mobile/screens/medicals/medical_details_screen.dart';
import 'package:doctodoc_mobile/screens/medicals/medical_documents_type_screen.dart';
import 'package:doctodoc_mobile/screens/notifications/notifications_screen.dart';
import 'package:doctodoc_mobile/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../screens/auth/otp_screen.dart';
import '../../screens/doctors/doctor_detail_screen.dart';
import '../../screens/doctors/doctor_search_screen.dart';
import '../../screens/medicals/medical_patient_details_screen.dart';
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
    MedicalDetailsScreen.routeName: (args) => MedicalDetailsScreen.routeBuilder(args),
    MedicalPatientDetailsScreen.routeName: (args) => MedicalPatientDetailsScreen.routeBuilder(args),
    MedicalDocumentsTypeScreen.routeName: (args) => MedicalDocumentsTypeScreen.routeBuilder(args),
    DoctorSearchScreen.routeName: (args) => const DoctorSearchScreen(),
    DoctorSearchScreen.routeName2: (args) => DoctorSearchScreen.routeBuilder(args),
    DoctorDetailScreen.routeName: (args) => DoctorDetailScreen.routeBuilder(args),
    AppointmentDetailScreen.routeName: (args) => AppointmentDetailScreen.routeBuilder(args),
    CareTrackingPermissionsScreen.routeName: (args) => CareTrackingPermissionsScreen.routeBuilder(args),
    DocumentCareTrackingDetailScreen.routeName: (args) => DocumentCareTrackingDetailScreen.routeBuilder(args),
    NotificationsScreen.routeName: (args) => const NotificationsScreen(),
    SaveGeneralDoctor.routeName: (args) => SaveGeneralDoctor.routeBuilder(args),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeBuilder = routes[settings.name];
    final nextScreen = routeBuilder == null
        ? const NotFoundScreen()
        : routeBuilder(settings.arguments);

    return MaterialPageRoute(builder: (context) => nextScreen);
  }
}
