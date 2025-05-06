import 'package:flutter/material.dart';

class ButtonBase extends StatelessWidget {
  final String label;
  final GestureTapCallback? onTap;
  final bool disabled;

  const ButtonBase({
    required this.label,
    super.key,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: disabled ? null : onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey;
              }
              return Theme.of(context).primaryColor;
            },
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16), //todo utiliser valeur du theme
        ),
      ),
    );
  }
}
