import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  secondaryHeaderColor: const Color.fromARGB(255, 21, 21, 24),
  colorScheme: ColorScheme.fromSeed(
      primary: Colors.blue,
      secondary: Colors.indigo,
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
      background: Colors.grey[900]),
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.notoSans(
      fontSize: 30,
      fontStyle: FontStyle.italic,
    ),
    bodyMedium: GoogleFonts.notoSans(),
    displaySmall: GoogleFonts.notoSans(),
  ),
);
