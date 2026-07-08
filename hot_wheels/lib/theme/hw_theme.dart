import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HwTheme {
  static const orange = Color(0xFFFF6B00);
  static const flame = Color(0xFFFF3D00);
  static const blue = Color(0xFF0066CC);
  static const darkBg = Color(0xFF0A0A0A);
  static const surface = Color(0xFF1A1A2E);
  static const card = Color(0xFF16213E);
  static const textDim = Color(0xFF8E8E93);

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    colorScheme: const ColorScheme.dark(
      primary: orange,
      secondary: blue,
      surface: surface,
      error: flame,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.bebasNeue(fontSize: 26, color: Colors.white, letterSpacing: 1),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
      titleLarge: GoogleFonts.bebasNeue(fontSize: 28, color: Colors.white),
      titleMedium: GoogleFonts.roboto(fontWeight: FontWeight.w600, color: Colors.white),
      bodyMedium: GoogleFonts.roboto(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
