import 'package:doctodoc_mobile/models/doctor/address.dart';
import 'package:doctodoc_mobile/models/doctor/doctor.dart';

class DoctorDetailed {
  final Doctor basicInformation;
  final String biography;
  final String rpps;
  final Address address;
  final List<String> languages;

  DoctorDetailed({
    required this.basicInformation,
    required this.biography,
    required this.rpps,
    required this.address,
    required this.languages,
  });

  factory DoctorDetailed.fromJson(Map<String, dynamic> json) {
    Doctor doctor = Doctor.fromJson(json);
    Address address = Address.fromJson(json['address']);
    final jsonLanguages = (json['languages'] as List?) ?? [];

    return DoctorDetailed(
      basicInformation: doctor,
      biography: json['biography'],
      rpps: json['rpps'],
      address: address,
      languages: List.from(jsonLanguages),
    );
  }
}
