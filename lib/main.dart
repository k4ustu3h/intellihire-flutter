import "package:dynamic_color/dynamic_color.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:intellihire/firebase_options.dart";
import "package:intellihire/pages/auth_gate.dart";
import "package:intellihire/util/ui/monet.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: "IntelliHire",
          theme: lightTheme(lightDynamic),
          darkTheme: darkTheme(darkDynamic),
          themeMode: ThemeMode.system,
          home: const AuthGate(),
        );
      },
    );
  }
}
