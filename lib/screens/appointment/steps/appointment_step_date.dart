import 'package:doctodoc_mobile/shared/widgets/inputs/select_day_input.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/inputs/base/input_choice.dart';
import '../../../shared/widgets/inputs/select_hour_input.dart';
import '../widgets/appointment_label.dart';

class AppointmentStepDate extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const AppointmentStepDate({
    super.key,
    required this.formKey,
  });

  @override
  State<AppointmentStepDate> createState() => _AppointmentStepDateState();
}

class _AppointmentStepDateState extends State<AppointmentStepDate> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
            const AppointmentLabel(label: "Choisir la date"),
            SelectDayInput(controller: _dateController),
            const AppointmentLabel(label: "Choisissez un horaire"),
            SelectHourInput(
              controller: _hourController,
              slots: const [
                SelectHourItem(startTime: "08:00", slotId: "08:00"),
                SelectHourItem(startTime: "09:00", slotId: "09:00"),
                SelectHourItem(startTime: "10:00", slotId: "10:00"),
                SelectHourItem(startTime: "11:00", slotId: "11:00"),
                SelectHourItem(startTime: "12:00", slotId: "12:00"),
                SelectHourItem(startTime: "13:00", slotId: "13:00"),
                SelectHourItem(startTime: "14:00", slotId: "14:00"),
                SelectHourItem(startTime: "15:00", slotId: "15:00"),
              ],
            ),
          ],
          ),
        ),
      ),
    );
  }
}
