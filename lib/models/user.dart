import 'package:doctodoc_mobile/models/auth.dart';

class User {
  final Auth auth;
  final String patientId;
  final String lastName;
  final String firstName;
  final String email;
  final String phoneNumber;
  final bool hasOnBoardingDone;

  User({
    required this.auth,
    required this.patientId,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.phoneNumber,
    required this.hasOnBoardingDone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Auth auth = Auth.fromJson(json);

    return User(
      auth: auth,
      patientId: json['id'] ?? '',
      lastName: json['lastName'] ?? '',
      firstName: json['firstName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      hasOnBoardingDone: json['hasOnBoardingDone'] ?? '',
    );
  }
}
