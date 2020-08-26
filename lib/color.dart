import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor main = MaterialColor(_mainPrimaryValue, <int, Color>{
    50: Color(0xFFE5EDE9),
    100: Color(0xFFBFD1C7),
    200: Color(0xFF95B2A2),
    300: Color(0xFF6A937D),
    400: Color(0xFF4A7C61),
    500: Color(_mainPrimaryValue),
    600: Color(0xFF255D3E),
    700: Color(0xFF1F5336),
    800: Color(0xFF19492E),
    900: Color(0xFF0F371F),
  });
  static const int _mainPrimaryValue = 0xFF2A6545;

  static const MaterialColor mainAccent = MaterialColor(_mainAccentValue, <int, Color>{
    100: Color(0xFF74FFA5),
    200: Color(_mainAccentValue),
    400: Color(0xFF0EFF63),
    700: Color(0xFF00F356),
  });
  static const int _mainAccentValue = 0xFF41FF84;
}