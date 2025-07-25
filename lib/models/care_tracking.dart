import 'package:doctodoc_mobile/models/doctor/doctor.dart';

import 'document.dart';

class AppointmentOfCareTracking {
  final String id;
  final String date;
  final String start;
  final Doctor doctor;

  AppointmentOfCareTracking({
    required this.id,
    required this.date,
    required this.start,
    required this.doctor,
  });

  factory AppointmentOfCareTracking.fromJson(Map<String, dynamic> json) {
    Doctor doctor = Doctor.fromJson(json['doctor']);
    return AppointmentOfCareTracking(
      id: json['id'],
      date: json['date'],
      start: json['start'],
      doctor: doctor,
    );
  }
}

enum CareTrackingStatus {
  open,
  closed,
}

class CareTracking {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String closedAt;
  final CareTrackingStatus status;
  final List<AppointmentOfCareTracking> appointments;

  CareTracking({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.closedAt,
    required this.status,
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
      createdAt: json['createdAt'],
      closedAt: json['closedAt'] ?? '',
      status: json['closedAt'] == null ? CareTrackingStatus.open : CareTrackingStatus.closed,
      appointments: appointments.length > 3 ? appointments.sublist(0, 3) : appointments,
    );
  }
}

class CareTrackingDetailed {
  final CareTracking careTracking;
  final List<Doctor> doctors;
  final List<AppointmentOfCareTracking> appointments;
  List<Document> documents;

  CareTrackingDetailed({
    required this.careTracking,
    required this.doctors,
    required this.appointments,
    this.documents = const [],
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

    final jsonDocumentsList = (json["documents"] as List?) ?? [];
    List<Document> documents =
        jsonDocumentsList.map((jsonElement) => Document.fromJson(jsonElement)).toList();

    return CareTrackingDetailed(
      careTracking: careTracking,
      doctors: doctors,
      appointments: appointments,
      documents: documents,
    );
  }
}
