import 'package:doctodoc_mobile/blocs/write_close_member_bloc/write_close_member_bloc.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/email_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/firstname_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/lastname_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../banners/info_banner.dart';
import '../buttons/primary_button.dart';
import '../inputs/birthdate_input.dart';
import '../inputs/gender_input.dart';
import 'base/modal_base.dart';

Future<CreatePatientRequest?> showCreatePatientModal(BuildContext context) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "Créer un patient",
          child: const CreatePatientModal(),
        ),
      ];
    },
  );
}

class CreatePatientModal extends StatefulWidget {
  const CreatePatientModal({super.key});

  @override
  State<CreatePatientModal> createState() => _CreatePatientModalState();
}

class _CreatePatientModalState extends State<CreatePatientModal> {
  final forgotPasswordKey = GlobalKey<FormState>();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  bool isSubmitted = false;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Column(
            children: [
              ..._buildOnSubmitted(),
              Form(
                key: forgotPasswordKey,
                child: Column(
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: "Créer le patient",
                disabled: isSubmitted,
                onTap: () => _createPatient(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOnSubmitted() {
    if (isSubmitted) {
      return [
        const InfoBanner(
          title: "Le patient a bien été créé",
        ),
        const SizedBox(height: 20),
      ];
    } else {
      return [const SizedBox.shrink()];
    }
  }

  void _createPatient() async {
    if (forgotPasswordKey.currentState?.validate() == false) {
      return;
    }
    print("Patient created: ${firstNameController.text} ${lastNameController.text}");
    //todo appel create patient
    _onCreateCloseMember();
    setState(() {
      isSubmitted = true;
    });
    // Simulate returning patient after creation
    Future.delayed(Duration.zero, () {
      Navigator.of(context)
          .pop(CreatePatientRequest(firstNameController.text, lastNameController.text, "mockedId"));
    });
  }

  _onCreateCloseMember() {
    final writeCloseMemberBloc = context.read<WriteCloseMemberBloc>();

    // todo Corentin fix
    final birthdate = "2003-04-10";
    final phoneNumber = "+33504030201";

    writeCloseMemberBloc.add(OnCreateCloseMember(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      birthdate: birthdate,
      gender: genderController.text,
      email: emailController.text,
      phoneNumber: phoneNumber,
    ));
  }
}

class CreatePatientRequest {
  final String firstName;
  final String lastName;
  final String id;

  CreatePatientRequest(this.firstName, this.lastName, this.id);
}
