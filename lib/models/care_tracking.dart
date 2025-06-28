import 'package:doctodoc_mobile/models/doctor/doctor.dart';

class AppointmentOfCareTracking {
  final String id;
  final String date;
  final Doctor doctor;

  AppointmentOfCareTracking({
    required this.id,
    required this.date,
    required this.doctor,
  });

  factory AppointmentOfCareTracking.fromJson(Map<String, dynamic> json) {
    Doctor doctor = Doctor.fromJson(json['doctor']);
    return AppointmentOfCareTracking(
      id: json['id'],
      date: json['date'],
      doctor: doctor,
    );
  }
}

class CareTracking {
  final String id;
  final String name;
  final String description;
  final List<AppointmentOfCareTracking> appointments;

  CareTracking({
    required this.id,
    required this.name,
    required this.description,
    required this.appointments,
  });

  factory CareTracking.fromJson(Map<String, dynamic> json) {
    final jsonAppointmentsList = (json["appointments"] as List?) ?? [];

    List<AppointmentOfCareTracking> appointments = jsonAppointmentsList
        .map((jsonElement) => AppointmentOfCareTracking.fromJson(jsonElement))
        .toList();

    return CareTracking(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      appointments: appointments.length > 3 ? appointments.sublist(0, 3) : appointments,
    );
  }
}

class CareTrackingDetailed {
  final CareTracking careTracking;
  final List<Doctor> doctors;
  final List<AppointmentOfCareTracking> appointments;

  CareTrackingDetailed({
    required this.careTracking,
    required this.doctors,
    required this.appointments,
  });

  factory CareTrackingDetailed.fromJson(Map<String, dynamic> json) {
    CareTracking careTracking = CareTracking.fromJson(json);

    final jsonDoctorsList = (json["doctors"] as List?) ?? [];
    List<Doctor> doctors =
        jsonDoctorsList.map((jsonElement) => Doctor.fromJson(jsonElement)).toList();

    final jsonAppointmentsList = (json["appointments"] as List?) ?? [];
    List<AppointmentOfCareTracking> appointments = jsonAppointmentsList
        .map((jsonElement) => AppointmentOfCareTracking.fromJson(jsonElement))
        .toList();

    return CareTrackingDetailed(
      careTracking: careTracking,
      doctors: doctors,
      appointments: appointments,
    );
  }
}
