class UpdateProfileRequest {
  final String firstName;
  final String lastName;
  final String birthdate;
  final String gender;

  UpdateProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
  });
}
