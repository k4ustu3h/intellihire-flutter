import "package:expressive_loading_indicator/expressive_loading_indicator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/textfields/auth_text_field.dart";
import "package:intellihire/layout/home_layout.dart";
import "package:intellihire/pages/auth/register.dart";
import "package:intellihire/util/ui/theme_controller.dart";
import "package:material_symbols_icons/symbols.dart";

class Login extends StatefulWidget {
  final ThemeController themeController;

  const Login({super.key, required this.themeController});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  late final List<Map<String, dynamic>> _fields;

  @override
  void initState() {
    super.initState();
    _fields = [
      {
        "controller": _emailController,
        "labelText": "Email",
        "iconName": "email",
        "obscureText": false,
        "validator": (String? v) =>
            v == null || v.isEmpty ? "Enter email" : null,
      },
      {
        "controller": _passwordController,
        "labelText": "Password",
        "iconName": "password",
        "obscureText": true,
        "validator": (String? v) =>
            v == null || v.isEmpty ? "Enter password" : null,
      },
    ];
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case "email":
        return Symbols.email_rounded;
      case "password":
        return Symbols.password;
      default:
        return Symbols.error;
    }
  }

  Future<void> signIn() async {
    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeLayout(
            title: "IntelliHire",
            themeController: widget.themeController,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final errorMessage =
          (e.code == "user-not-found" || e.code == "wrong-password")
          ? "Invalid email or password."
          : e.message ?? "Login failed.";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(height: MediaQuery.of(context).padding.top),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            Text("Welcome Back", style: textTheme.displaySmall),
            Text("Login to your account", style: textTheme.titleMedium),
            ..._fields.map((field) {
              return AuthTextField(
                controller: field["controller"],
                label: field["labelText"],
                icon: _getIconData(field["iconName"]),
                obscure: field["obscureText"],
                validator: field["validator"],
              );
            }),
            FilledButton.icon(
              onPressed: _loading ? null : signIn,
              icon: Icon(Symbols.login_rounded),
              label: _loading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: ExpressiveLoadingIndicator(),
                    )
                  : Text("Sign In"),
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        Register(themeController: widget.themeController),
                  ),
                );
              },
              child: Text("Don't have an account? Register here."),
            ),
          ],
        ),
      ),
    );
  }
}
