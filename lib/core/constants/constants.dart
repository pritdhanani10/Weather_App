import 'package:flutter/material.dart';

class Urls {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey = 'cc95d932d5a45d33a9527d5019475f2c';
  
  static String currentWeatherByName(String city) =>
      '$baseUrl/weather?q=$city&appid=$apiKey&units=metric';

  static String weatherIcon(String iconCode) =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';
}

/// Design system tokens generated via Stitch MCP (Aetherial Midnight Glass)
class AppTheme {
  // Canvases & Backgrounds
  static const Color voidBase = Color(0xFF0A0E27);
  static const Color deepMidnight = Color(0xFF0D1538);
  static const Color surfaceContainer = Color(0xFF1A1E37);
  static const Color surfaceContainerLow = Color(0xFF161A33);

  // Translucent Glass Tiers
  static const Color glassSurfaceLow = Color(0x730D1538);
  static const Color glassSurfaceStandard = Color(0x0FFFFFFF);
  static const Color glassSurfaceElevated = Color(0x1FFFFFFF);
  static const Color glassBorder = Color(0x1FFFFFFF);
  static const Color glassBorderHighlight = Color(0x33FFFFFF);

  // Accents & Gradients
  static const Color electricCyan = Color(0xFF00F2FE);
  static const Color ionBlue = Color(0xFF4FACFE);
  static const Color borealisViolet = Color(0xFF7F00FF);
  static const Color violetGlow = Color(0xFFA18CD1);
  static const Color amberSun = Color(0xFFFFB300);
  static const Color hazardRed = Color(0xFFFF4565);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB8FFFFFF);
  static const Color textMuted = Color(0x73FFFFFF);
  static const Color textCyan = Color(0xFFE0FDFF);
}