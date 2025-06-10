class Doctor {
  final String id;
  final String firstName;
  final String lastName;
  final String speciality;
  final String pictureUrl;

  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.speciality,
    required this.pictureUrl,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      speciality: json['speciality'],
      pictureUrl: json['pictureUrl'],
    );
  }
}
