import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Custom theme extension for brand colors
@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  const BrandColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.surface,
  });

  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color surface;

  @override
  BrandColors copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? surface,
  }) {
    return BrandColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      surface: surface ?? this.surface,
    );
  }

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) {
    if (other is! BrandColors) return this;
    return BrandColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
    );
  }
}

class AppTheme {
  static const _primaryLight = Color(0xFF6750A4);
  static const _secondaryLight = Color(0xFF625B71);
  static const _tertiaryLight = Color(0xFF7D5260);
  static const _surfaceLight = Color(0xFFFFFBFE);

  static const _primaryDark = Color(0xFFD0BCFF);
  static const _secondaryDark = Color(0xFFCCC2DC);
  static const _tertiaryDark = Color(0xFFEFB8C8);
  static const _surfaceDark = Color(0xFF1C1B1F);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: _primaryLight,
      secondary: _secondaryLight,
      tertiary: _tertiaryLight,
      surface: _surfaceLight,
      background: const Color(0xFFFFFBFE),
    ),
    textTheme: GoogleFonts.interTextTheme(),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: _primaryLight,
    ),
    extensions: const [
      BrandColors(
        primary: _primaryLight,
        secondary: _secondaryLight,
        tertiary: _tertiaryLight,
        surface: _surfaceLight,
      ),
    ],
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: _primaryDark,
      secondary: _secondaryDark,
      tertiary: _tertiaryDark,
      surface: _surfaceDark,
      background: const Color(0xFF1C1B1F),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: _primaryDark,
    ),
    extensions: const [
      BrandColors(
        primary: _primaryDark,
        secondary: _secondaryDark,
        tertiary: _tertiaryDark,
        surface: _surfaceDark,
      ),
    ],
  );
}
