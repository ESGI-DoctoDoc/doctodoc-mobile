import 'package:doctodoc_mobile/shared/widgets/inputs/base/utils/input_decoration.dart';
import 'package:flutter/material.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const OtpInput({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  //todo refaire le otp
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 6,
      decoration:
          buildInputDecoration(context: context, label: "", hintText: "", icon: null),
      onChanged: (value) {
        onSubmit();
      },
    );
  }
}
