class Address {
  final String address;
  final double latitude;
  final double longitude;

  Address({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
