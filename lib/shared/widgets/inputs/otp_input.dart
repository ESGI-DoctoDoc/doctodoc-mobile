import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final Function onSubmit;

  const OtpInput({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  //todo refaire le otp
  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      numberOfFields: 6,
      borderColor: Colors.black,
      showFieldAsBox: true,
      onCodeChanged: (onChanged) {
        onSubmit(onChanged);
      },
      onSubmit: (onSubmit) {
        this.onSubmit(onSubmit);
      },
    );
  }
}
