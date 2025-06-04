import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/birthdate_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/email_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/gender_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/write_close_member_bloc/write_close_member_bloc.dart';
import '../buttons/primary_button.dart';
import '../inputs/firstname_input.dart';
import '../inputs/lastname_input.dart';
import 'base/modal_base.dart';

Future<Patient?> showUpdatePatientModal(
  BuildContext context,
  Patient patient,
) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Modifier le patient",
          child: _UpdatePatientWidget(patient: patient),
        ),
      ];
    },
  );
}

class _UpdatePatientWidget extends StatefulWidget {
  final Patient patient;

  const _UpdatePatientWidget({required this.patient});

  @override
  State<_UpdatePatientWidget> createState() => _UpdatePatientWidgetState();
}

class _UpdatePatientWidgetState extends State<_UpdatePatientWidget> {
  final GlobalKey<FormState> updatePatientKey = GlobalKey<FormState>();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    genderController.text = widget.patient.gender;
    firstNameController.text = widget.patient.firstName;
    lastNameController.text = widget.patient.lastName;
    emailController.text = widget.patient.email;
    phoneController.text = widget.patient.phoneNumber.replaceFirst(RegExp(r'^\+33\s?'), '0');
    birthdateController.text =
        Jiffy.parse(widget.patient.birthdate, pattern: "yyyy-MM-dd").format(pattern: "dd/MM/yyyy");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: updatePatientKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                GenderInput(controller: genderController, onChange: (value) {}),
                const SizedBox(height: 10),
                FirstnameInput(controller: firstNameController),
                const SizedBox(height: 10),
                LastnameInput(controller: lastNameController),
                const SizedBox(height: 10),
                EmailInput(controller: emailController),
                const SizedBox(height: 10),
                PhoneInput(controller: phoneController),
                const SizedBox(height: 10),
                BirthdateInput(controller: birthdateController),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: "Mettre à jour les informations",
                  onTap: () => _updatePatient(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updatePatient() {
    if (updatePatientKey.currentState!.validate()) {
      // final updatedPatient = Patient(
      //   id: widget.patient.id,
      //   firstName: firstNameController.text,
      //   lastName: lastNameController.text,
      // );
      Navigator.of(context).pop(/*updatedPatient*/);

      final writeCloseMemberBloc = context.read<WriteCloseMemberBloc>();
      writeCloseMemberBloc.add(OnUpdateCloseMember(
        id: widget.patient.id,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        birthdate: Jiffy.parse(birthdateController.text, pattern: "dd/MM/yyyy")
            .format(pattern: "yyyy-MM-dd"),
        gender: genderController.text,
        email: emailController.text,
        phoneNumber: "+33${phoneController.text.substring(1)}".replaceAll(" ", ""),
      ));
    }
  }
}
