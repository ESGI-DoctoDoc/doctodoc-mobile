class Today {
  final String slotId;
  final String date;
  final String start;
  final String end;
  final bool isBooked;

  Today({
    required this.slotId,
    required this.date,
    required this.start,
    required this.end,
    required this.isBooked,
  });

  factory Today.fromJson(Map<String, dynamic> json) {
    return Today(
      slotId: json['slotId'],
      date: json['date'],
      start: json['start'],
      end: json['end'],
      isBooked: json['isBooked'],
    );
  }
}

class MedicalConcernAppointmentAvailability {
  final List<Today> today;
  final String? next;
  final String? previous;

  MedicalConcernAppointmentAvailability({
    required this.today,
    required this.next,
    required this.previous,
  });

  factory MedicalConcernAppointmentAvailability.fromJson(Map<String, dynamic> json) {
    final jsonToday = (json['today'] as List?) ?? [];
    List<Today> today = jsonToday.map((jsonElement) => Today.fromJson(jsonElement)).toList();

    return MedicalConcernAppointmentAvailability(
      today: today,
      next: json["next"] ?? '',
      previous: json["previous"] ?? '',
    );
  }
}
