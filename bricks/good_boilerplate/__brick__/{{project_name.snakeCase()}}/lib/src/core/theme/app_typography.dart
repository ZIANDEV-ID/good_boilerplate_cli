import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
{{#theme_style_soft_pastel}}
  static String? get fontFamily => GoogleFonts.poppins().fontFamily;

  static TextTheme get textTheme => GoogleFonts.poppinsTextTheme(_baseTextTheme);
{{/theme_style_soft_pastel}}
{{#theme_style_neubrutalism}}
  static String? get fontFamily => GoogleFonts.spaceGrotesk().fontFamily;

  static TextTheme get textTheme =>
      GoogleFonts.spaceGroteskTextTheme(_baseTextTheme);
{{/theme_style_neubrutalism}}

  static const _baseTextTheme = TextTheme(
    displaySmall: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.15,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.25,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.45,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
  );
}
