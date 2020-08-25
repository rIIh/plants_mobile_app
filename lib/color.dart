import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor main = MaterialColor(_mainPrimaryValue, <int, Color>{
    50: Color(0xFFF6F9E9),
    100: Color(0xFFE9EFC9),
    200: Color(0xFFDAE4A5),
    300: Color(0xFFCBD981),
    400: Color(0xFFBFD166),
    500: Color(_mainPrimaryValue),
    600: Color(0xFFADC344),
    700: Color(0xFFA4BC3B),
    800: Color(0xFF9CB533),
    900: Color(0xFF8CA923),
  });
  
  static const int _mainPrimaryValue = 0xFFB4C94B;

  static const MaterialColor mainAccent = MaterialColor(_mainAccentValue, <int, Color>{
    100: Color(0xFFF9FFE5),
    200: Color(_mainAccentValue),
    400: Color(0xFFE2FF80),
    700: Color(0xFFDCFF66),
  });
  static const int _mainAccentValue = 0xFFEEFFB3;
}