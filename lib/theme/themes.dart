import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Color.fromARGB(255, 255, 255, 255),
    primary: Color.fromARGB(255, 241, 242, 244),
    secondary: Color.fromARGB(255, 220, 223, 228),
    tertiary: Color.fromARGB(255, 179, 185, 196),
    inverseSurface: Color.fromARGB(255, 22, 26, 29),
    inversePrimary: Color.fromARGB(255, 29, 33, 37),
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: Color.fromARGB(255, 22, 26, 29),
    primary: Color.fromARGB(255, 29, 33, 37),
    secondary: Color.fromARGB(255, 34, 38, 43),
    tertiary: Color.fromARGB(255, 44, 51, 58),
    inverseSurface: Color.fromARGB(255, 255, 255, 255),
    inversePrimary: Color.fromARGB(255, 241, 242, 244),
  ),
);
