import 'appointment_flow_address_data.dart';

class AppointmentFlowDoctorData {
  final String doctorId;
  final String firstName;
  final String lastName;
  final String pictureUrl;
  final AppointmentFlowAddressData address;

  const AppointmentFlowDoctorData({
    required this.doctorId,
    required this.firstName,
    required this.lastName,
    required this.pictureUrl,
    required this.address,
  });
}
