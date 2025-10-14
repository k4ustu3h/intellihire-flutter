import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";

const _brandSeedColor = Colors.blueAccent;

final _lightColorScheme = ColorScheme.fromSeed(seedColor: _brandSeedColor);
final _darkColorScheme = ColorScheme.fromSeed(
  seedColor: _brandSeedColor,
  brightness: Brightness.dark,
);

ThemeData _buildTheme(ColorScheme baseScheme) {
  final scheme = baseScheme.harmonized();

  return ThemeData(
    colorScheme: scheme,
    bottomSheetTheme: BottomSheetThemeData(showDragHandle: true),
  );
}

ThemeData lightTheme(ColorScheme? dynamicColorScheme) {
  return _buildTheme(dynamicColorScheme ?? _lightColorScheme);
}

ThemeData darkTheme(ColorScheme? dynamicColorScheme) {
  return _buildTheme(dynamicColorScheme ?? _darkColorScheme);
}
