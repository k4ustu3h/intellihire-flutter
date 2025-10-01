import "package:expressive_loading_indicator/expressive_loading_indicator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/layout/home_layout.dart";
import "package:intellihire/pages/auth/login.dart";

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: ExpressiveLoadingIndicator()));
        }
        if (snapshot.hasData) {
          return HomeLayout(title: "IntelliHire");
        } else {
          return Login();
        }
      },
    );
  }
}
