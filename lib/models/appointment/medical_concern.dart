class MedicalConcern {
  final String id;
  final String name;

  MedicalConcern({
    required this.id,
    required this.name,
  });

  factory MedicalConcern.fromJson(Map<String, dynamic> json) {
    return MedicalConcern(
      id: json['id'],
      name: json['name'],
    );
  }
}
