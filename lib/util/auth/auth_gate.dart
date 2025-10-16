import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/loading/loading_indicator.dart";
import "package:intellihire/layout/home_layout.dart";
import "package:intellihire/pages/auth/login.dart";
import "package:intellihire/util/ui/theme_controller.dart";

class AuthGate extends StatelessWidget {
  final ThemeController themeController;

  const AuthGate({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: LoadingIndicator()));
        }

        if (snapshot.hasData) {
          return HomeLayout(themeController: themeController);
        }
        return Login(themeController: themeController);
      },
    );
  }
}
