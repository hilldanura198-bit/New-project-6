import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  const AppTypography._();

  // Glyphic style fallback for tagline and "Buat Akun".
  static TextStyle glyphic({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.cinzel(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
