class Auth {
  final String token;

  const Auth({
    required this.token,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      token: json['token'],
    );
  }
}
