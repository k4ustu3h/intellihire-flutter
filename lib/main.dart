import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:intellihire/firebase_options.dart";
import "package:intellihire/intellihire.dart";
import "package:intellihire/util/ui/theme_controller.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final themeController = await ThemeController.load();

  runApp(IntelliHire(themeController: themeController));
}
