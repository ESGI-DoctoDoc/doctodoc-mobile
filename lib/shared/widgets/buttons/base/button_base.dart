import 'package:flutter/material.dart';

class ButtonBase extends StatefulWidget {
  final String label;
  final GestureTapCallback? onTap;
  final bool disabled;
  final Color? textColor;
  final Color? bgColor;

  const ButtonBase({
    required this.label,
    super.key,
    this.onTap,
    this.disabled = false,
    this.textColor = Colors.black,
    this.bgColor,
  });

  @override
  State<ButtonBase> createState() => _ButtonBaseState();
}

class _ButtonBaseState extends State<ButtonBase> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: widget.disabled ? null : widget.onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(fontSize: 16, color: widget.textColor),
        ),
      ),
    );
  }
}
