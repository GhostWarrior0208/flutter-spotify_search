import 'package:flutter/material.dart';
import './app_colors.dart';
import './text_styles.dart';

class TextThemes {
  /// Main text theme

  static TextTheme get textTheme {
    return const TextTheme(
      bodyLarge: AppTextStyles.bodyLg,
      bodyMedium: AppTextStyles.bodyMd,
      bodySmall: AppTextStyles.bodySm,
      titleLarge: AppTextStyles.titleLg,
      titleMedium: AppTextStyles.titleMd,
      titleSmall: AppTextStyles.titleSm,
    );
  }

  /// Primary text theme

  static TextTheme get primaryTextTheme {
    return TextTheme(
      bodyLarge: AppTextStyles.bodyLg.copyWith(color: AppColors.primary),
      bodyMedium: AppTextStyles.bodyMd.copyWith(color: AppColors.primary),
      bodySmall: AppTextStyles.bodySm.copyWith(color: AppColors.primary),
      titleSmall: AppTextStyles.titleSm.copyWith(color: AppColors.primary),
      titleMedium: AppTextStyles.titleMd.copyWith(color: AppColors.primary),
      titleLarge: AppTextStyles.titleLg.copyWith(color: AppColors.primary),
    );
  }

  /// Dark text theme

  static TextTheme get darkTextTheme {
    return TextTheme(
      bodyLarge: AppTextStyles.bodyLg.copyWith(color: AppColors.white),
      bodyMedium: AppTextStyles.bodyMd.copyWith(color: AppColors.white),
      bodySmall: AppTextStyles.bodySm.copyWith(color: AppColors.white),
      titleSmall: AppTextStyles.titleSm.copyWith(color: AppColors.white),
      titleMedium: AppTextStyles.titleMd.copyWith(color: AppColors.white),
      titleLarge: AppTextStyles.titleLg.copyWith(color: AppColors.white),
    );
  }
}
