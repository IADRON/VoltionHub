import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.laranjaVoltion,
      scaffoldBackgroundColor: AppColors.branco,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.laranjaVoltion,
        secondary: AppColors.azulVoltion,
        tertiary: AppColors.cinzaEscuro,
        background: AppColors.branco,
        surface: AppColors.branco,
        onPrimary: AppColors.branco,
        onSecondary: AppColors.branco,
        onBackground: AppColors.cinzaEscuro,
        onSurface: AppColors.cinzaEscuro,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.laranjaVoltion,
      scaffoldBackgroundColor: AppColors.azulVoltion,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColors.laranjaVoltion,
        secondary: AppColors.laranjaVoltion,
        tertiary: AppColors.laranjaVoltion,
        background: AppColors.azulVoltion,
        surface: AppColors.azulVoltion,
        onPrimary: AppColors.branco,
        onSecondary: AppColors.branco,
        onBackground: AppColors.branco,
        onSurface: AppColors.branco,
      ),
    );
  }
}