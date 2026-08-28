import 'package:flutter/material.dart';

class AppStyles {
  static bool get _isDark {
    try {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    } catch (_) {
      return false;
    }
  }

  static Color get bgColor =>
      _isDark ? const Color(0xFF121212) : const Color(0xFFFAFFFB);
  static Color get background =>
      _isDark ? const Color.fromARGB(255, 1, 1, 1) : const Color(0xFFFAFAFA);

  static Color get textDark =>
      _isDark ? const Color(0xFFE0E0E0) : const Color(0xFF212121);
  static Color get textMuted => _isDark
      ? const Color(0xFFA0A0A0)
      : const Color(0xFF777777); // Uniformisé avec 0xFF777777
  static Color get textInverse =>
      _isDark ? const Color(0xFF212121) : Colors.white;

  
  static Color get primary =>
      _isDark ? const Color(0xFF7FB685) : const Color(0xFF2D6A4F);
  static Color get primarySoft =>
      _isDark ? const Color(0xFF1E3324) : const Color(0xFFDDEDDF);
  static Color get navbarColor =>
      _isDark ? const Color(0xFF2C4A32) : const Color(0xFF7FB685);

  static const Color primaryOrange = Color(0xFFE67E22);
  static const Color accentBlue = Color(0xFF0066CC);
  static const Color badgeRed = Color(0xFFEF5350);

  
  static Color get boxSurfaceLight =>
      _isDark ? const Color(0xFF252525) : const Color(0xFFE2F0E7);
  static Color get cardMenuYellow =>
      _isDark ? const Color(0xFF4A3B1C) : const Color(0xFFFFEEC1);
  static Color get avatarOrangeBg =>
      _isDark ? const Color(0xFF4D3319) : const Color(0xFFFFE0B2);

  static const Color successGreen = Color(0xFF0AA361);

  
  static Color get iconColor =>
      _isDark ? const Color(0xFFB0BEC5) : const Color(0xFF2E4D32);

  static Color get borderColor =>
      _isDark ? const Color(0xFF3A5A40) : const Color(0xFFA3D9A5);
  static Color get borderSelected =>
      _isDark ? const Color(0xFF66FF99) : const Color(0xFF4CD97B);

  static Color get shadowColor => _isDark
      ? Colors.white.withValues(alpha: 0.05)
      : Colors.black.withValues(
          alpha: 0.12,
        ); // Harmonisé (fusion de 0.18 et 0.04)

  
  static TextStyle get headingTextStyle => TextStyle(
    fontSize: 20,
    color: textDark,
    fontWeight: FontWeight.bold,
    fontFamily: 'Quicksand',
  );

  static TextStyle get titleTextStyle => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: textDark,
  );

  static TextStyle get normalTextStyle => TextStyle(
    fontSize: 18,
    color: textDark,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter',
  );
}
