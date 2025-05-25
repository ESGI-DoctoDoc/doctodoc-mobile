import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage buildModalPage({
  required BuildContext context,
  required Widget child,
  String? title,
  VoidCallback? onClose,
}) {
  return WoltModalSheetPage(
    hasSabGradient: false,
    hasTopBarLayer: false,
    pageTitle: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: title != null ? Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ) : null,
    ),
    isTopBarLayerAlwaysVisible: true,
    trailingNavBarWidget: IconButton(
      padding: const EdgeInsets.all(20),
      icon: const Icon(Icons.close),
      onPressed: onClose ?? () => Navigator.of(context).pop(),
    ),
    child: child,
  );
}