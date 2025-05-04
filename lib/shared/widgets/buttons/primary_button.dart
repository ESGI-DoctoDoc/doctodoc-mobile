import 'package:doctodoc_mobile/shared/widgets/buttons/base/button_base.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final GestureTapCallback? onTap;

  const PrimaryButton({
    required this.label,
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      label: label,
      onTap: onTap,
    );
  }
}
