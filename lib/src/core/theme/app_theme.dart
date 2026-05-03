import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFFFDFBF7);
  static const Color darkBackground = Color(0xFF1A1714);
  static const Color primaryBlue = Color(0xFF2E4A7D);
  static const Color accentGold = Color(0xFFC8A96B);

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        surface: background,
        onSurface: Color(0xFF1F1A15),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F1A15),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFFFFEFC),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34),
        ),
        shadowColor: const Color(0x1A2C2218),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 42,
          fontWeight: FontWeight.w700,
          height: 1.1,
          color: Colors.black87,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 34,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F1A15),
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F1A15),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2E261D),
          height: 1.4,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF5A4C3D),
          height: 1.4,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF7A6A56),
          height: 1.4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8F3E8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: primaryBlue, width: 1.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF2B251E),
          foregroundColor: const Color(0xFFF5E7CA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF3E3224),
          side: const BorderSide(color: Color(0x33A98653)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
      dividerColor: const Color(0x1FA98653),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        surface: Color(0xFF25201B),
        onSurface: Color(0xFFF1E5CC),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFF2E8D4),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF231E19),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 42,
          fontWeight: FontWeight.w700,
          height: 1.1,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 34,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFF2E8D4),
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFF2E8D4),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFF1E5CC),
          height: 1.4,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFD2C2A8),
          height: 1.4,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFB8A890),
          height: 1.4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A241E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: accentGold, width: 1.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFC8A96B),
          foregroundColor: const Color(0xFF1C1713),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF1E5CC),
          side: const BorderSide(color: Color(0x4DC8A96B)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
      dividerColor: const Color(0x33C8A96B),
    );
  }
}
