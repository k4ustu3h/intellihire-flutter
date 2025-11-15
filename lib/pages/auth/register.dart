import "package:expressive_loading_indicator/expressive_loading_indicator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/textfields/auth_text_field.dart";
import "package:intellihire/layout/home_layout.dart";
import "package:intellihire/pages/auth/login.dart";
import "package:intellihire/util/ui/theme_controller.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:simple_icons/simple_icons.dart";

class Register extends StatefulWidget {
  final ThemeController themeController;

  const Register({super.key, required this.themeController});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _loading = false;

  late final List<Map<String, dynamic>> _fields;
  late final List<Map<String, dynamic>> _buttons;

  @override
  void initState() {
    super.initState();
    _fields = [
      {
        "controller": _nameController,
        "focusNode": _nameFocus,
        "labelText": "Name",
        "iconName": "name",
        "obscureText": false,
        "onSubmit": (_) => _emailFocus.requestFocus(),
        "textInputAction": TextInputAction.next,
        "validator": (String? v) =>
            v == null || v.isEmpty ? "Enter your name" : null,
      },
      {
        "controller": _emailController,
        "focusNode": _emailFocus,
        "labelText": "Email",
        "iconName": "email",
        "obscureText": false,
        "onSubmit": (_) => _passwordFocus.requestFocus(),
        "textInputAction": TextInputAction.next,
        "validator": (String? v) =>
            v == null || v.isEmpty ? "Enter email" : null,
      },
      {
        "controller": _passwordController,
        "focusNode": _passwordFocus,
        "labelText": "Password",
        "iconName": "password",
        "obscureText": true,
        "onSubmit": (_) => signUp(),
        "textInputAction": TextInputAction.done,
        "validator": (String? v) =>
            v == null || v.length < 6 ? "Password too short" : null,
      },
    ];

    _buttons = [
      {"label": "Continue with Google", "iconName": "google"},
      {"label": "Continue with Apple", "iconName": "apple"},
    ];
  }

  IconData _getIconData(String iconName) => switch (iconName) {
    "name" => Symbols.person_rounded,
    "email" => Symbols.email_rounded,
    "password" => Symbols.password,
    "google" => SimpleIcons.google,
    "apple" => SimpleIcons.apple,
    _ => Symbols.error,
  };

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      await userCredential.user?.updateDisplayName(_nameController.text.trim());
      await userCredential.user?.reload();

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeLayout(
            title: "IntelliHire",
            themeController: widget.themeController,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final errorMessage = switch (e.code) {
        "weak-password" => "The password provided is too weak.",
        "email-already-in-use" => "An account already exists for that email.",
        _ => e.message ?? "Registration failed.",
      };
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _emailFocus.dispose();
    _nameFocus.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: .fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(height: MediaQuery.of(context).padding.top),
      ),
      body: Padding(
        padding: const .all(16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              Text("Create an Account", style: textTheme.displaySmall),
              Text("Enter your details", style: textTheme.titleMedium),
              ..._fields.map((field) {
                return AuthTextField(
                  controller: field["controller"],
                  label: field["labelText"],
                  icon: _getIconData(field["iconName"]),
                  obscure: field["obscureText"],
                  validator: field["validator"],
                  focusNode: field["focusNode"],
                  textInputAction: field["textInputAction"],
                  onFieldSubmitted: field["onSubmit"],
                );
              }),
              FilledButton.icon(
                onPressed: _loading ? null : signUp,
                icon: const Icon(Symbols.app_registration_rounded),
                label: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: ExpressiveLoadingIndicator(),
                      )
                    : const Text("Sign Up"),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                ),
              ),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: .symmetric(horizontal: 10),
                    child: Text("Or", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              ..._buttons.map((button) {
                return FilledButton.icon(
                  icon: Icon(_getIconData(button["iconName"])),
                  label: Text(button["label"]),
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                  ),
                );
              }),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          Login(themeController: widget.themeController),
                    ),
                  );
                },
                child: const Text("Already have an account? Login here."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
