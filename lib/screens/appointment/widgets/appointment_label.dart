import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentLabel extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const AppointmentLabel({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        Visibility(
          visible: onTap != null,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: IconButton(
            icon: const Icon(CupertinoIcons.add),
            onPressed: onTap,
          ),
        ),
      ],
    );
  }
}
