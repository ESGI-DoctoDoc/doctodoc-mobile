import 'package:doctodoc_mobile/models/address.dart';
import 'package:doctodoc_mobile/models/doctor/doctor.dart';

class OpeningHours {
  final String day;
  final String hours;

  OpeningHours({
    required this.day,
    required this.hours,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    final start = json['start'];
    final end = json['end'];

    final hours = (start != null && end != null) ? "$start - $end" : "Fermé";

    print(hours);

    return OpeningHours(
      day: json['day'],
      hours: hours,
    );
  }

  static Map<String, String> openingHoursListToMap(List<OpeningHours> list) {
    return {
      for (var openingHour in list) openingHour.day: openingHour.hours,
    };
  }
}

class DoctorDetailed {
  final Doctor basicInformation;
  final String biography;
  final String rpps;
  final Address address;
  final List<String> languages;
  final List<OpeningHours> openingHours;

  DoctorDetailed({
    required this.basicInformation,
    required this.biography,
    required this.rpps,
    required this.address,
    required this.languages,
    required this.openingHours,
  });

  factory DoctorDetailed.fromJson(Map<String, dynamic> json) {
    Doctor doctor = Doctor.fromJson(json);
    Address address = Address.fromJson(json['address']);
    final jsonLanguages = (json['languages'] as List?) ?? [];

    final jsonOpeningHours = (json['openingHours'] as List?) ?? [];
    List<OpeningHours> openingHours =
        jsonOpeningHours.map((jsonElement) => OpeningHours.fromJson(jsonElement)).toList();

    return DoctorDetailed(
      basicInformation: doctor,
      biography: json['biography'],
      rpps: json['rpps'],
      address: address,
      languages: List.from(jsonLanguages),
      openingHours: openingHours,
    );
  }
}
