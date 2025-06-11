import '../doctor/doctor.dart';

class Appointment {
  final String id;
  final String date;
  final String start;
  final String end;
  final String address;
  final Doctor doctor;

  Appointment({
    required this.id,
    required this.date,
    required this.start,
    required this.end,
    required this.address,
    required this.doctor,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    Doctor doctor = Doctor.fromJson(json['doctor']);

    return Appointment(
      id: json['id'],
      date: json['date'],
      start: json['start'],
      end: json['end'],
      address: json['address'],
      doctor: doctor,
    );
  }
}
