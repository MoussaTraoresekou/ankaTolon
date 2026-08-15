import 'package:flutter/material.dart';

class AppStyles {
  // Style principal des grands titres
  static const headingTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.black87,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
  );

  // Style des titres
  static const titleTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: Colors.black87,
  );

  // Style du contenu principal
  static const normalTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.black87,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter',
  );

  // Couleurs de la charte graphique
  static const mainColor = Color(0xFF1591EA);
  static const primaryOrange = Color(0xFFE67E22);
  static const pastelBg = Color(0xFFE3F2FD);
}