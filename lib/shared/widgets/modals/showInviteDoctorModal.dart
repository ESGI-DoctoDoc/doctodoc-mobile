import 'package:doctodoc_mobile/blocs/doctor_blocs/doctor_recruitment_bloc/doctor_recruitment_bloc.dart';
import 'package:doctodoc_mobile/shared/widgets/banners/info_banner.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/firstname_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/lastname_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../utils/show_error_snackbar.dart';
import '../buttons/primary_button.dart';
import 'base/modal_base.dart';

Future<bool?> showInviteDoctorModal(BuildContext context) async {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        buildModalPage(
          context: context,
          title: "On contacte votre médecin traitant",
          child: const _InviteDoctorWidget(),
        ),
      ];
    },
  );
}

class _InviteDoctorWidget extends StatefulWidget {
  const _InviteDoctorWidget();

  @override
  State<_InviteDoctorWidget> createState() => _InviteDoctorWidgetState();
}

class _InviteDoctorWidgetState extends State<_InviteDoctorWidget> {
  final GlobalKey<FormState> inviteDoctorKey = GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorRecruitmentBloc, DoctorRecruitmentState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: _doctorRecruitmentListener,
      child: Form(
        key: inviteDoctorKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  FirstnameInput(controller: _firstnameController),
                  const SizedBox(height: 10),
                  LastnameInput(controller: _lastnameController),
                  const SizedBox(height: 10),
                  const InfoBanner(
                      title:
                          "Nous allons contacter votre médecin traitant pour l'inviter à rejoindre Doctodoc."),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: "Inviter mon médecin",
                    onTap: () => _inviteDoctor(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _inviteDoctor() {
    if (inviteDoctorKey.currentState!.validate()) {
      context.read<DoctorRecruitmentBloc>().add(
            OnDoctorRecruitment(
              firstName: _firstnameController.text,
              lastName: _lastnameController.text,
            ),
          );
    }
  }

  void _doctorRecruitmentListener(BuildContext context, DoctorRecruitmentState state) {
    if (state.status == DoctorRecruitmentStatus.success) {
      Navigator.of(context).pop(true);
    } else if (state.status == DoctorRecruitmentStatus.error) {
      showErrorSnackbar(context, state.exception);
    }
    // todo loading mettre un loader
  }
}
