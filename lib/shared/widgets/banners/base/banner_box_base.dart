import 'package:flutter/material.dart';

enum BannerSeverity {
  info,
  success,
  warning,
  error,
}

class BannerBoxBase extends StatelessWidget {
  final String title;
  final BannerSeverity severity;

  const BannerBoxBase({super.key,
    required this.title,
    this.severity = BannerSeverity.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getTextColor().withAlpha(50),
        ),
      ),
      child: Row(
        children: [
          Icon(_getIcon(), color: _getTextColor()),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: _getTextColor()),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (severity) {
      case BannerSeverity.info:
        return Colors.blue.shade50;
      case BannerSeverity.success:
        return Colors.green.shade50;
      case BannerSeverity.warning:
        return Colors.yellow.shade50;
      case BannerSeverity.error:
        return Colors.red.shade50;
    }
  }

  Color _getTextColor() {
    switch (severity) {
      case BannerSeverity.info:
        return Colors.blue.shade900;
      case BannerSeverity.success:
        return Colors.green.shade900;
      case BannerSeverity.warning:
        return Colors.yellow.shade900;
      case BannerSeverity.error:
        return Colors.red.shade900;
    }
  }

  IconData _getIcon() {
    switch (severity) {
      case BannerSeverity.info:
        return Icons.info_outline;
      case BannerSeverity.success:
        return Icons.check_circle_outline;
      case BannerSeverity.warning:
        return Icons.warning_amber_outlined;
      case BannerSeverity.error:
        return Icons.error_outline;
    }
  }
}
