class Speciality {
  final String name;

  Speciality({
    required this.name,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      name: json['name'],
    );
  }
}
