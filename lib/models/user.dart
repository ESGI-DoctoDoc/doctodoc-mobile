import 'package:doctodoc_mobile/models/patient.dart';

class User {
  final String token;
  final Patient patientInfos;
  final bool hasOnBoardingDone;
  final List<Patient> closeMembers;

  User({
    required this.token,
    required this.patientInfos,
    required this.hasOnBoardingDone,
    this.closeMembers = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Patient patient = Patient.fromJson(json);

    return User(
      token: json['token'] ?? '',
      patientInfos: patient,
      hasOnBoardingDone: json['hasOnBoardingDone'] ?? false,
    );
  }
}
