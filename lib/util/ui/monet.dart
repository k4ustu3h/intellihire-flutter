import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";

const _brandSeedColor = Colors.blueAccent;

final _lightColorScheme = ColorScheme.fromSeed(seedColor: _brandSeedColor);
final _darkColorScheme = ColorScheme.fromSeed(
  seedColor: _brandSeedColor,
  brightness: Brightness.dark,
);

ThemeData lightTheme(ColorScheme? dynamicColorScheme) {
  return ThemeData(
    colorScheme: (dynamicColorScheme ?? _lightColorScheme).harmonized(),
  );
}

ThemeData darkTheme(ColorScheme? dynamicColorScheme) {
  return ThemeData(
    colorScheme: (dynamicColorScheme ?? _darkColorScheme).harmonized(),
  );
}
