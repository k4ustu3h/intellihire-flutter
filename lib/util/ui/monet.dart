import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:material_symbols_icons/material_symbols_icons.dart";

const _brandSeedColor = Colors.blueAccent;

final _lightColorScheme = ColorScheme.fromSeed(seedColor: _brandSeedColor);
final _darkColorScheme = ColorScheme.fromSeed(
  seedColor: _brandSeedColor,
  brightness: Brightness.dark,
);

Widget monet({
  required bool useDynamicTheme,
  required Widget Function(ColorScheme? light, ColorScheme? dark) builder,
}) {
  return DynamicColorBuilder(
    builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme? lightScheme;
      ColorScheme? darkScheme;

      if (lightDynamic != null && darkDynamic != null) {
        lightScheme = ColorScheme.fromSeed(
          seedColor: Color(lightDynamic.primary.toARGB32()),
          brightness: Brightness.light,
        ).harmonized();

        darkScheme = ColorScheme.fromSeed(
          seedColor: Color(darkDynamic.primary.toARGB32()),
          brightness: Brightness.dark,
        ).harmonized();
      }
      return builder(
        useDynamicTheme ? lightScheme : null,
        useDynamicTheme ? darkScheme : null,
      );
    },
  );
}

ThemeData lightTheme(ColorScheme? dynamicColorScheme) {
  return _buildTheme(dynamicColorScheme ?? _lightColorScheme);
}

ThemeData darkTheme(ColorScheme? dynamicColorScheme) {
  return _buildTheme(dynamicColorScheme ?? _darkColorScheme);
}

ThemeData _buildTheme(ColorScheme baseScheme) {
  final scheme = baseScheme.harmonized();

  final buttonShape = WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
    final radius = states.contains(WidgetState.pressed) ? 8.0 : 24.0;
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
  });

  final switchTheme = SwitchThemeData(
    thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Icon(Symbols.check_rounded, size: 18);
      } else {
        return Icon(Symbols.close_rounded, size: 18);
      }
    }),
  );

  return ThemeData(
    colorScheme: scheme,
    bottomSheetTheme: BottomSheetThemeData(showDragHandle: true),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(shape: buttonShape),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(shape: buttonShape),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(shape: buttonShape),
    ),
    switchTheme: switchTheme,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(shape: buttonShape),
    ),
  );
}
