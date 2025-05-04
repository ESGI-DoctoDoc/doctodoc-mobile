import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF34C759);
  static const Color secondary = Color(0xFF625B71);
  static const Color background = Color(0xFFEFEFEF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB3261E);
  static const Color success = Color(0xFF4CAF50);
  static const Color info = Color(0xFF2196F3);
  static const Color warning = Color(0xFFFFC107);
}

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    error: AppColors.error,
  ),
  textTheme: Typography.blackMountainView,
  extensions: const <ThemeExtension<dynamic>>[
    CustomColors(
      success: AppColors.success,
      info: AppColors.info,
      warning: AppColors.warning,
    ),
  ],
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: Colors.grey[900]!,
    error: AppColors.error,
  ),
  textTheme: Typography.whiteMountainView,
  extensions: const <ThemeExtension<dynamic>>[
    CustomColors(
      success: AppColors.success,
      info: AppColors.info,
      warning: AppColors.warning,
    ),
  ],
);

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.success,
    required this.info,
    required this.warning,
  });

  final Color success;
  final Color info;
  final Color warning;

  @override
  CustomColors copyWith({
    Color? success,
    Color? info,
    Color? warning,
  }) {
    return CustomColors(
      success: success ?? this.success,
      info: info ?? this.info,
      warning: warning ?? this.warning,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}