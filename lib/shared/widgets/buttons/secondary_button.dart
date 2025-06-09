import 'package:flutter/material.dart';

import 'base/button_base.dart';

class SecondaryButton extends StatefulWidget {
  final String label;
  final GestureTapCallback? onTap;

  const SecondaryButton({super.key,
    required this.label,
    this.onTap,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      bgColor: Colors.white,
      label: widget.label,
      onTap: widget.onTap,
      borderColor: Border.all(color: Theme.of(context).dividerColor.withAlpha(77), width: 2),
    );
  }
}
