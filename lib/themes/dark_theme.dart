
import 'package:flutter/material.dart';

class DarkTheme {

  static final ColorScheme _colorScheme = ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.green);

  static final ThemeData theme = ThemeData.dark().copyWith(
    colorScheme: _colorScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      foregroundColor: _colorScheme.onBackground,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    )
  );
}