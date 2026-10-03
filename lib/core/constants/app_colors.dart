import 'package:flutter/material.dart';

abstract class AppColors {
  // Deep Orange Theme
  static const Color primary = Color(0xFFFF6D00);        // Deep Orange 500
  static const Color primaryLight = Color(0xFFFF9E40);   // Deep Orange 300
  static const Color primaryDark = Color(0xFFE65100);    // Deep Orange 700
  static const Color primaryVariant = Color(0xFFBF360C); // Deep Orange 900

  static const Color secondary = Color(0xFFFFCC80);      // Deep Orange 100
  static const Color secondaryLight = Color(0xFFFFE0B2); // Deep Orange 50
  static const Color secondaryDark = Color(0xFFFFB74D);  // Deep Orange 200

  // Surface & Background
  static const Color background = Color(0xFFFFF8F1);     // Deep Orange 50 (light background)
  static const Color surface = Color(0xFFFFFFFF);        // White
  static const Color surfaceVariant = Color(0xFFFFF3E0); // Deep Orange 50

  // Text Colors
  static const Color primaryText = Color(0xFF1A1A1A);    // Near black
  static const Color secondaryText = Color(0xFF757575);  // Grey 600
  static const Color onPrimary = Color(0xFFFFFFFF);      // White
  static const Color onSecondary = Color(0xFF1A1A1A);    // Near black

  // Status Colors
  static const Color error = Color(0xFFD32F2F);          // Red 700
  static const Color errorLight = Color(0xFFEF9A9A);     // Red 100
  static const Color success = Color(0xFF2E7D32);        // Green 700
  static const Color successLight = Color(0xFFA5D6A7);   // Green 100
  static const Color warning = Color(0xFFF57F17);        // Amber 900
  static const Color warningLight = Color(0xFFFFF59D);   // Amber 100
  static const Color info = Color(0xFF0288D1);           // Blue 700
  static const Color infoLight = Color(0xFFB3E5FC);      // Blue 100

  // Divider & Border
  static const Color divider = Color(0xFFFFCC80);        // Deep Orange 100
  static const Color border = Color(0xFFFFE0B2);         // Deep Orange 50

  // Snackbar
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}