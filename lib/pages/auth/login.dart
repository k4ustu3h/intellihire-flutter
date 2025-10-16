import "package:easy_localization/easy_localization.dart";
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
        "labelText": "email".tr(),
        "iconName": "email",
        "obscureText": false,
        "validator": (String? v) =>
            v == null || v.isEmpty ? "enter_email".tr() : null,
      },
      {
        "controller": _passwordController,
        "labelText": "password".tr(),
        "iconName": "password",
        "obscureText": true,
        "validator": (String? v) =>
            v == null || v.isEmpty ? "enter_password".tr() : null,
      },
    ];
  }

  IconData _getIconData(String iconName) => switch (iconName) {
    "email" => Symbols.email_rounded,
    "password" => Symbols.password,
    _ => Symbols.error,
  };

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
          builder: (_) => HomeLayout(themeController: widget.themeController),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final errorMessage =
          (e.code == "user-not-found" || e.code == "wrong-password")
          ? "invalid_email_password".tr()
          : e.message ?? "login_failed".tr();
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
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            Text("welcome_back".tr(), style: textTheme.displaySmall),
            Text("login_to_account".tr(), style: textTheme.titleMedium),
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
              icon: const Icon(Symbols.login_rounded),
              label: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: ExpressiveLoadingIndicator(),
                    )
                  : Text("sign_in".tr()),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        Register(themeController: widget.themeController),
                  ),
                );
              },
              child: Text("dont_have_account".tr()),
            ),
          ],
        ),
      ),
    );
  }
}
