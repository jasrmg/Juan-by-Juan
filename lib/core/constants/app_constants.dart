import 'package:flutter/material.dart';

/// app wide constants for consistent spacing, sizing and styling
class AppConstants {
  AppConstants._();

  // spacing
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;

  // icon sizes
  static const double iconSizeLarge = 64.0;

  // text sizes
  static const double textSizeBody = 16.0;
  static const double textSizeTitle = 18.0;

  // loading spinner
  static const double spinnerSize = 20.0;
  static const double spinnerStrokeWidth = 2.0;

  // padding/margins
  static const EdgeInsets cardMarginBottom = EdgeInsets.only(bottom: 8);
  static const EdgeInsets buttonPaddingVertical = EdgeInsets.symmetric(
    vertical: 16,
  );
  static const EdgeInsets screenPadding = EdgeInsets.all(16);
}
