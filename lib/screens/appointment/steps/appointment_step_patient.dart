import 'package:flutter/cupertino.dart';

class AppointmentStepPatient extends StatelessWidget {
  final Function onNext;

  const AppointmentStepPatient({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("AppointmentStepPatient"),
    );
  }
}
