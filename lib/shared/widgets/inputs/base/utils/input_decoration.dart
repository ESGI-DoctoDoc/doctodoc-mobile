import 'package:flutter/material.dart';
import 'package:doctodoc_mobile/shared/config/theme.dart';

InputDecoration buildInputDecoration({
  required BuildContext context,
  required String label,
  required String hintText,
  required IconData? icon,
}) {
  const inputBorderRadius = 12.0;
  const inputHeight = 18.0;

  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(inputBorderRadius),
      borderSide: BorderSide(
        color: Theme.of(context).extension<CustomColors>()!.success.withValues(),
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(inputBorderRadius),
      borderSide: BorderSide(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        width: 0.5,
      ),
    ),
    hintText: hintText,
    label: Text(label),
    contentPadding: const EdgeInsets.all(inputHeight),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(inputBorderRadius),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.white,
    suffixIcon: Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    ),
    errorStyle: const TextStyle(
      color: Colors.red,
      height: 3,
    ),
  );
}