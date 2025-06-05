import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatefulWidget {
  static const String routeName = '/doctors/:doctorId';

  //todo mélissa convertir pour avoir le doctorId
  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, routeName);
  }

  final String doctorId;

  const DoctorDetailScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Text("Doctor ID ${widget.doctorId}");
  }
}
