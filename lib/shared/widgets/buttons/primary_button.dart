import 'package:doctodoc_mobile/shared/widgets/buttons/base/button_base.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final GestureTapCallback? onTap;
  final bool disabled;

  const PrimaryButton({
    required this.label,
    super.key,
    this.disabled = false,
    this.onTap,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      disabled: widget.disabled,
      label: widget.label,
      onTap: widget.onTap,
    );
  }
}
