import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
{{#theme_style_soft_pastel}}
  static const _componentRadius = 18.0;
  static const _borderWidth = 1.0;
  static const _buttonElevation = 0.0;
{{/theme_style_soft_pastel}}
{{#theme_style_neubrutalism}}
  static const _componentRadius = 0.0;
  static const _borderWidth = 2.0;
  static const _buttonElevation = 4.0;
{{/theme_style_neubrutalism}}

  static ThemeData get light => _buildTheme(Brightness.light);

  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark
        ? AppColors.darkBackground
        : AppColors.background;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final foreground = isDark ? Colors.white : AppColors.textPrimary;
    final borderColor = isDark ? const Color(0xFFE9E2DE) : AppColors.border;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: surface,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_componentRadius),
      side: BorderSide(color: borderColor, width: _borderWidth),
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(_componentRadius),
      borderSide: BorderSide(color: borderColor, width: _borderWidth),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: foreground,
        displayColor: foreground,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
      ),
      cardColor: surface,
      dividerColor: borderColor,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: foreground,
        contentTextStyle: TextStyle(color: background),
        behavior: SnackBarBehavior.floating,
        shape: shape,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primarySoft;
          }
          return borderColor;
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: _buttonElevation,
          shadowColor: AppColors.shadow,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: shape,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(52),
          shape: shape,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
