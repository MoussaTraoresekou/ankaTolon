import 'package:flutter/material.dart';

extension AppStyles on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get bgColor =>
      _isDark ? const Color(0xFF121212) : const Color(0xFFFAFFFB);
  Color get background =>
      _isDark ? const Color.fromARGB(255, 1, 1, 1) : const Color(0xFFFAFAFA);

  Color get textDark =>
      _isDark ? const Color(0xFFE0E0E0) : const Color(0xFF212121);
  Color get textMuted =>
      _isDark ? const Color(0xFFA0A0A0) : const Color(0xFF777777);
  Color get textInverse => _isDark ? const Color(0xFF212121) : Colors.white;

  Color get primary =>
      _isDark ? const Color(0xFF7FB685) : const Color(0xFF2D6A4F);
  Color get primarySoft =>
      _isDark ? const Color(0xFF1E3324) : const Color(0xFFDDEDDF);
  Color get navbarColor =>
      _isDark ? const Color(0xFF2C4A32) : const Color(0xFF7FB685);

  Color get primaryOrange => Color(0xFFE67E22);
  Color get accentBlue => Color(0xFF0066CC);
  Color get badgeRed => Color(0xFFEF5350);

  Color get boxSurfaceLight =>
      _isDark ? const Color(0xFF252525) : const Color(0xFFE2F0E7);
  Color get cardMenuYellow =>
      _isDark ? const Color(0xFF4A3B1C) : const Color(0xFFFFEEC1);
  Color get avatarOrangeBg =>
      _isDark ? const Color(0xFF4D3319) : const Color(0xFFFFE0B2);

  Color get successGreen => Color(0xFF0AA361);

  Color get iconColor =>
      _isDark ? const Color(0xFFB0BEC5) : const Color(0xFF2E4D32);

  Color get borderColor =>
      _isDark ? const Color(0xFF3A5A40) : const Color(0xFFA3D9A5);
  Color get borderSelected =>
      _isDark ? const Color(0xFF66FF99) : const Color(0xFF4CD97B);

  Color get shadowColor => _isDark
      ? Colors.white.withValues(alpha: 0.05)
      : Colors.black.withValues(alpha: 0.12);

  TextStyle get headingTextStyle => TextStyle(
    fontSize: 20,
    color: textDark,
    fontWeight: FontWeight.bold,
    fontFamily: 'Quicksand',
  );

  TextStyle get titleTextStyle => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: textDark,
  );

  TextStyle get normalTextStyle => TextStyle(
    fontSize: 18,
    color: textDark,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter',
  );
}
