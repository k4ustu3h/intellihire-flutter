import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:intellihire/util/auth/auth_gate.dart";
import "package:intellihire/util/ui/monet.dart";
import "package:intellihire/util/ui/theme_controller.dart";

class IntelliHire extends StatelessWidget {
  final ThemeController themeController;

  const IntelliHire({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeController,
      builder: (context, useDynamicTheme, _) {
        return DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            return MaterialApp(
              title: "IntelliHire",
              theme: lightTheme(useDynamicTheme ? lightDynamic : null),
              darkTheme: darkTheme(useDynamicTheme ? darkDynamic : null),
              themeMode: ThemeMode.system,
              home: AuthGate(themeController: themeController),
            );
          },
        );
      },
    );
  }
}
