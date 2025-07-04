class CareTrackingForAppointment {
  final String id;
  final String name;
  final String description;

  CareTrackingForAppointment({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CareTrackingForAppointment.fromJson(Map<String, dynamic> json) {
    return CareTrackingForAppointment(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
