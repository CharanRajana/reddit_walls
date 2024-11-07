import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reddit_walls/src/utils/extensions.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.rubik().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF6314),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: context.colorScheme.onInverseSurface,
          backgroundColor: context.colorScheme.inverseSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(size: 24),
        ),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.rubik().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF6314),
        brightness: Brightness.dark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: context.colorScheme.inverseSurface,
          backgroundColor: context.colorScheme.onInverseSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(size: 24),
        ),
      ),
    );
  }
}
