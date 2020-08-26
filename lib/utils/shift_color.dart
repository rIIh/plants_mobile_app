import 'package:flutter/material.dart';

Color shiftColorLuminance(Color color, int amount) {
  var r = color.red + amount;

  if (r > 255) {
    r = 255;
  } else if  (r < 0) r = 0;

  var b = color.blue + amount;

  if (b > 255) {
    b = 255;
  } else if  (b < 0) b = 0;

  var g = color.green + amount;

  if (g > 255) {
    g = 255;
  } else if (g < 0) g = 0;

  return Color.fromARGB(color.alpha, r, g, b);
}