import 'package:flutter/material.dart';

class ButtonBase extends StatelessWidget {
  final String label;
  final GestureTapCallback? onTap;

  const ButtonBase({
    required this.label,
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).primaryColor,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 16), //todo utiliser valeur du theme
        ),
      ),
    );
  }
}
