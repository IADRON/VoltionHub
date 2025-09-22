import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.orange,
      scaffoldBackgroundColor: AppColors.white,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.orange,
        secondary: AppColors.blue,
        tertiary: AppColors.darkGrey,
        background: AppColors.white,
        surface: AppColors.white,
        onPrimary: AppColors.white,
        onSecondary: AppColors.icons,
        onBackground: AppColors.darkGrey,
        onSurface: AppColors.darkGrey,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.orange,
      scaffoldBackgroundColor: AppColors.blue,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColors.orange,
        secondary: AppColors.orange,
        tertiary: AppColors.orange,
        background: AppColors.blue,
        surface: AppColors.blue,
        onPrimary: AppColors.white,
        onSecondary: AppColors.icons,
        onBackground: AppColors.white,
        onSurface: AppColors.white,
      ),
    );
  }
}