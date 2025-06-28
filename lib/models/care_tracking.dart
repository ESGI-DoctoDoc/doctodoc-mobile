class CareTracking {
  final String id;
  final String name;
  final String description;

  CareTracking({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CareTracking.fromJson(Map<String, dynamic> json) {
    return CareTracking(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
