import 'package:doctodoc_mobile/models/patient.dart';

abstract class RegisterDataSource {
  Future<void> register(String email, String password, String phoneNumber);

  Future<Patient> onBoarding(
    String firstName,
    String lastName,
    String birthdate,
    String gender,
    String? referentDoctorId,
  );
}
