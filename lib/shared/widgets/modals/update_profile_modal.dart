import 'package:doctodoc_mobile/blocs/user_blocs/write_user_bloc/write_user_bloc.dart';
import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/birthdate_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/gender_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../buttons/primary_button.dart';
import '../inputs/firstname_input.dart';
import '../inputs/lastname_input.dart';
import 'base/modal_base.dart';

Future<Patient?> showUpdateProfileModal(
  BuildContext context,
  Patient patient,
) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Modifier mon profil",
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
  final TextEditingController birthdateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    genderController.text = widget.patient.gender;
    firstNameController.text = widget.patient.firstName;
    lastNameController.text = widget.patient.lastName;
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
                BirthdateInput(controller: birthdateController),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: "Mettre à jour les informations",
                  onTap: () => _updateProfile(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateProfile() {
    if (updatePatientKey.currentState!.validate()) {
      final writeUserBloc = context.read<WriteUserBloc>();

      writeUserBloc.add(
        OnUpdateProfile(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          birthdate: Jiffy.parse(birthdateController.text, pattern: "dd/MM/yyyy")
              .format(pattern: "yyyy-MM-dd"),
          gender: genderController.text,
        ),
      );

      Navigator.of(context).pop();
    }
  }
}
