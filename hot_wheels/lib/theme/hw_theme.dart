import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HwTheme {
  HwTheme._();

  // ── Brand colors (same in both modes) ──
  static const brandOrange = Color(0xFFFF6B00);
  static const brandFlame = Color(0xFFFF3D00);
  static const brandBlue = Color(0xFF0066CC);

  // ── Backward compat aliases (deprecated, remove during migration) ──
  static const orange = brandOrange;
  static const flame = brandFlame;
  static const blue = brandBlue;

  static const darkBg = Color(0xFF0A0A0A);
  static const surface = Color(0xFF1A1A2E);
  static const card = Color(0xFF16213E);
  static const textDim = Color(0xFF8E8E93);

  // ── Light Theme ──

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F7),
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandOrange,
      brightness: Brightness.light,
      primary: brandOrange,
      secondary: brandBlue,
      error: brandFlame,
      surface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 1,
      titleTextStyle: GoogleFonts.bebasNeue(
          fontSize: 26, color: const Color(0xFF1A1A1A), letterSpacing: 1),
      iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: GoogleFonts.robotoTextTheme().copyWith(
      titleLarge: GoogleFonts.bebasNeue(
          fontSize: 28, color: const Color(0xFF1A1A1A)),
      titleMedium: GoogleFonts.roboto(
          fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A)),
      bodyMedium: GoogleFonts.roboto(color: const Color(0xFF666666)),
      bodySmall: GoogleFonts.roboto(color: const Color(0xFF999999)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFEEEEEE),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
    dividerColor: const Color(0xFFE0E0E0),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFEEEEEE),
      selectedColor: brandOrange.withAlpha(30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  // ── Dark Theme ──

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandOrange,
      brightness: Brightness.dark,
      primary: brandOrange,
      secondary: brandBlue,
      error: brandFlame,
      surface: const Color(0xFF1A1A2E),
      onSurface: Colors.white,
      onPrimary: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A1A2E),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.bebasNeue(
          fontSize: 26, color: Colors.white, letterSpacing: 1),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF16213E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
      titleLarge:
          GoogleFonts.bebasNeue(fontSize: 28, color: Colors.white),
      titleMedium: GoogleFonts.roboto(
          fontWeight: FontWeight.w600, color: Colors.white),
      bodyMedium: GoogleFonts.roboto(color: Colors.white70),
      bodySmall: GoogleFonts.roboto(color: Colors.white38),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1A2E),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      hintStyle: const TextStyle(color: Colors.white38),
    ),
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: Color(0xFF1A1A2E)),
    dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF16213E)),
    dividerColor: Colors.white12,
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1A1A2E),
      selectedColor: brandOrange.withAlpha(30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  // ── Quick context accessors ──

  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color surfaceColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color backgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static Color cardBg(BuildContext context) =>
      Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface;

  static Color textPrimaryColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color textSecondaryColor(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.color!;

  static Color textDimColor(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.color!;

  static Color divider(BuildContext context) =>
      Theme.of(context).dividerColor;
}
