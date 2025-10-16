import "package:easy_localization/easy_localization.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:intellihire/firebase_options.dart";
import "package:intellihire/intellihire.dart";
import "package:intellihire/util/ui/theme_controller.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final themeController = await ThemeController.load();

  runApp(
    EasyLocalization(
      fallbackLocale: const Locale("en"),
      path: "assets/translations",
      supportedLocales: const [Locale("en"), Locale("hi")],
      child: IntelliHire(themeController: themeController),
    ),
  );
}
