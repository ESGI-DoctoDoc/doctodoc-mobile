import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/close_member_blocs/write_close_member_bloc/write_close_member_bloc.dart';
import '../buttons/primary_button.dart';
import 'base/modal_base.dart';

Future<Patient?> showUpdatePhoneModal(
    BuildContext context,
    String phone,
    ) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Modifier mon numéro de téléphone",
          child: _UpdatePhoneWidget(phone: phone),
        ),
      ];
    },
  );
}

class _UpdatePhoneWidget extends StatefulWidget {
  final String phone;

  const _UpdatePhoneWidget({required this.phone});

  @override
  State<_UpdatePhoneWidget> createState() => _UpdatePhoneWidgetState();
}

class _UpdatePhoneWidgetState extends State<_UpdatePhoneWidget> {
  final GlobalKey<FormState> updatePhoneKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: updatePhoneKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                const SizedBox(height: 20),
                PhoneInput(controller: phoneController),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: "Envouer le code de validation",
                  onTap: () => _todo(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _todo() {
    if (updatePhoneKey.currentState!.validate()) {
      final writeCloseMemberBloc = context.read<WriteCloseMemberBloc>();
      // todo mélissa
      // writeCloseMemberBloc.add(OnUpdate(
      //   id: widget.patient.id,
      //   phone: phoneController.text,
      // ));

      Navigator.of(context).pop();
    }
  }
}
