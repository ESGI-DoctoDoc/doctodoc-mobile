import 'package:doctodoc_mobile/shared/widgets/buttons/base/button_base.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ButtonBase(
      disabled: disabled,
      label: label,
      onTap: onTap,
    );
  }
}
