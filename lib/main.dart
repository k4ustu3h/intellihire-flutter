import "package:dynamic_color/dynamic_color.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:intellihire/firebase_options.dart";
import "package:intellihire/util/auth/auth_gate.dart";
import "package:intellihire/util/ui/monet.dart";
import "package:intellihire/util/ui/theme_controller.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final themeController = await ThemeController.load();

  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;

  const MyApp({super.key, required this.themeController});

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
