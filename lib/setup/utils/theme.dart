// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

final appTheme = ThemeData(
  colorScheme: const ColorScheme(
    primary: Color(0xFF1B293A),
    secondary: Color(0xFF3F51B5),
    surfaceTint: Color(0xFFFF4081),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurfaceVariant: Colors.black,
    primaryVariant: Color(0xFF1B293A),
    secondaryVariant: Color(0xFF3F51B5),
    surfaceVariant: Color(0xFFFF4081),
    onSurface: Colors.white,
    onBackground: Colors.black,
    surface: Colors.white,
    background: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Colors.grey.shade200,
  cardTheme: CardTheme(
    color: Colors.white,
    shadowColor: Colors.black54.withOpacity(0.2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    hintStyle: const TextStyle(color: Colors.black54),
  ),
);
