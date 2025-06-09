import 'package:flutter/material.dart';

import 'base/button_base.dart';

class ErrorButton extends StatefulWidget {
  final String label;
  final GestureTapCallback? onTap;

  const ErrorButton({super.key,
    required this.label,
    this.onTap,
  });

  @override
  State<ErrorButton> createState() => _ErrorButtonState();
}

class _ErrorButtonState extends State<ErrorButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      bgColor: Colors.red.shade400,
      label: widget.label,
      onTap: widget.onTap,
    );
  }
}
