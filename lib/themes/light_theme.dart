
import 'package:flutter/material.dart';

class LightTheme {

  static final ColorScheme _colorScheme = ColorScheme.fromSeed(seedColor: Colors.green[900]!);

  static final ThemeData theme = ThemeData(
    colorScheme: _colorScheme,
    useMaterial3: true,

    // appBarTheme: AppBarTheme(
    //   foregroundColor: _colorScheme.onBackground,
    //   backgroundColor: _colorScheme.background,
    //   elevation: 0,
    // )
  );
}