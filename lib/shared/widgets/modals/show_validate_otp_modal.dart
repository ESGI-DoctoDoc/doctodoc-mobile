import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/otp_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/close_member_blocs/write_close_member_bloc/write_close_member_bloc.dart';
import '../buttons/primary_button.dart';
import 'base/modal_base.dart';

Future<Patient?> showValidateOtp(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Confirmer le code de vérification",
          child: _ValidateOtpWidget(),
        )
      ];
    },
  );
}

class _ValidateOtpWidget extends StatefulWidget {
  const _ValidateOtpWidget();

  @override
  State<_ValidateOtpWidget> createState() => _ValidateOtpWidgetState();
}

class _ValidateOtpWidgetState extends State<_ValidateOtpWidget> {
  final GlobalKey<FormState> validateOtpKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: validateOtpKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Column(
              children: [
                OtpInput(
                  controller: _otpController,
                  onSubmit: (value) {
                    if(value.length == 6) {
                      _confirmOtp();
                    }
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmOtp() {
    if (validateOtpKey.currentState!.validate()) {
      //todo mélissa
      navigateToProfile();
    }
  }

  void navigateToProfile() {
    Navigator.pop(context);
  }
}
