import 'package:doctodoc_mobile/models/address.dart';

import '../doctor/doctor.dart';

class Patient {
  final String id;
  final String lastName;
  final String firstName;
  final String email;

  Patient({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.email,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      email: json['email'],
    );
  }
}

class AppointmentDetailed {
  final String id;
  final String medicalConcern;
  final double price;
  final String date;
  final String takenAt;
  final String start;
  final String end;
  final Address address;
  final Doctor doctor;
  final Patient patient;

  AppointmentDetailed({
    required this.id,
    required this.medicalConcern,
    required this.price,
    required this.date,
    required this.takenAt,
    required this.start,
    required this.end,
    required this.address,
    required this.doctor,
    required this.patient,
  });

  factory AppointmentDetailed.fromJson(Map<String, dynamic> json) {
    Doctor doctor = Doctor.fromJson(json['doctor']);
    Address address = Address.fromJson(json['address']);
    Patient patient = Patient.fromJson(json['patient']);

    return AppointmentDetailed(
      id: json['id'],
      medicalConcern: json['medicalConcern'],
      price: json['price'],
      date: json['date'],
      takenAt: json['takenAt'],
      start: json['start'],
      end: json['end'],
      address: address,
      doctor: doctor,
      patient: patient,
    );
  }
}
