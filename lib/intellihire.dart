import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:heroine/heroine.dart";
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
        return monet(
          useDynamicTheme: useDynamicTheme,
          builder: (lightDynamic, darkDynamic) {
            return MaterialApp(
              title: "IntelliHire",
              theme: lightTheme(lightDynamic),
              darkTheme: darkTheme(darkDynamic),
              themeMode: ThemeMode.system,
              locale: context.locale,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              navigatorObservers: [HeroineController()],
              home: AuthGate(themeController: themeController),
            );
          },
        );
      },
    );
  }
}
