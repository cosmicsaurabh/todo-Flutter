import 'package:flutter/material.dart';
import 'package:todo/app_colors.dart';
import 'package:todo/core/constants/app_colors.dart';

class ThemeViewModel with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeData get currentTheme => isDarkMode ? _darkTheme : _lightTheme;

  // Light Theme Configuration
  final ThemeData _lightTheme = ThemeData(
    useMaterial3: true, // Enable Material 3 design
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: CustomAppColors.primary,
      secondary: CustomAppColors.secondary,
      surface: CustomAppColors.backgroundLight,
      error: CustomAppColors.error,
      onPrimary: CustomAppColors.onPrimary,
      onSecondary: CustomAppColors.onSecondary,
      onSurface: CustomAppColors.textLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: CustomAppColors.primary,
      foregroundColor: CustomAppColors.onPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: CustomAppColors.surfaceLight,
      elevation: 1,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: CustomAppColors.textLight,
        fontWeight: FontWeight.bold,
      ),
      // Add other text styles as needed
    ),
    dividerTheme: DividerThemeData(
      color: CustomAppColors.dividerLight,
      thickness: 1,
      space: 1,
    ),
    // Add other theme properties as needed
  );

  // Dark Theme Configuration
  final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: CustomAppColors.primaryDark,
      secondary: CustomAppColors.secondaryDark,
      surface: CustomAppColors.backgroundDark,
      error: CustomAppColors.errorDark,
      onPrimary: CustomAppColors.onPrimaryDark,
      onSecondary: CustomAppColors.onSecondaryDark,
      onSurface: CustomAppColors.textDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: CustomAppColors.backgroundDark,
      foregroundColor: CustomAppColors.textDark,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: CustomAppColors.surfaceDark,
      elevation: 1,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: CustomAppColors.textDark,
        fontWeight: FontWeight.bold,
      ),
      // Add other text styles as needed
    ),
    dividerTheme: DividerThemeData(
      color: CustomAppColors.dividerDark,
      thickness: 1,
      space: 1,
    ),
  );

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
