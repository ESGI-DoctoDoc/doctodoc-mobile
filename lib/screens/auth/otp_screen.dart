import 'package:flutter/material.dart';
import '../../shared/widgets/inputs/otp_input.dart';

class OtpWidget extends StatefulWidget {
  final Function()? onSubmit;

  const OtpWidget({
    super.key,
    this.onSubmit
  });

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  final TextEditingController codeController = TextEditingController();

  void _submitCode() {
    print("Code validé : ${codeController.text}");
    if (widget.onSubmit != null) {
      widget.onSubmit!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Demander votre code de vérification"),
        const SizedBox(height: 20),
        OtpInput(
          controller: codeController,
          onSubmit: _submitCode,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vérification du compte")),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: OtpWidget(),
      ),
    );
  }
}
