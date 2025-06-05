class Patient {
  final String id;
  final String lastName;
  final String firstName;
  final String gender;
  final String email;
  final String phoneNumber;
  final String birthdate;

  Patient({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.birthdate,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? '',
      lastName: json['lastName'] ?? '',
      firstName: json['firstName'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      birthdate: json['birthdate'] ?? '',
    );
  }
}
