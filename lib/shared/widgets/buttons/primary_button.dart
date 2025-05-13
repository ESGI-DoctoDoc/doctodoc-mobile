import 'package:doctodoc_mobile/shared/widgets/buttons/base/button_base.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final GestureTapCallback? onTap;
  final bool disabled;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.disabled = false,
    this.isLoading = false,
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
      isLoading: widget.isLoading,
      label: widget.label,
      onTap: widget.onTap,
    );
  }
}
