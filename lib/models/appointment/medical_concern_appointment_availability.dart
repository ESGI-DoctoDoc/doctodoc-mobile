class MedicalConcernAppointmentAvailability {
  final String slotId;
  final String date;
  final String start;
  final String end;
  final bool isBooked;

  MedicalConcernAppointmentAvailability({
    required this.slotId,
    required this.date,
    required this.start,
    required this.end,
    required this.isBooked,
  });

  factory MedicalConcernAppointmentAvailability.fromJson(Map<String, dynamic> json) {
    return MedicalConcernAppointmentAvailability(
      slotId: json['slotId'],
      date: json['date'],
      start: json['start'],
      end: json['end'],
      isBooked: json['isBooked'],
    );
  }
}
