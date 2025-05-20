class Patient {
  final String id;
  final String lastName;
  final String firstName;
  final String email;
  final String phoneNumber;

  Patient({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.phoneNumber,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? '',
      lastName: json['lastName'] ?? '',
      firstName: json['firstName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}
