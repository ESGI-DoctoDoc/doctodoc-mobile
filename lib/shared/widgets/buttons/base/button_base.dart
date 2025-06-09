import 'package:flutter/material.dart';

class ButtonBase extends StatefulWidget {
  final String label;
  final GestureTapCallback? onTap;
  final bool disabled;
  final bool isLoading;
  final Color? textColor;
  final Color? bgColor;
  final Border? borderColor;

  const ButtonBase({
    required this.label,
    super.key,
    this.onTap,
    this.disabled = false,
    this.isLoading = false,
    this.textColor = Colors.black,
    this.bgColor,
    this.borderColor,
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
        onPressed: widget.disabled || widget.isLoading ? null : widget.onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            widget.disabled || widget.isLoading
                ? Colors.grey
                : (widget.bgColor ?? Theme.of(context).primaryColor),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: widget.borderColor?.top.color ?? Colors.transparent,
                width: widget.borderColor?.top.width ?? 0,
              ),
            ),
          ),
        ),
        child: widget.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white, // Couleur de l'indicateur
                ),
              )
            : Text(
                widget.label,
                style: TextStyle(fontSize: 16, color: widget.textColor),
              ),
      ),
    );
  }
}
