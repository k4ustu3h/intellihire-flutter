import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/pages/register.dart";
import "package:material_symbols_icons/symbols.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
      },
      {
        "controller": _passwordController,
        "labelText": "Password",
        "iconName": "password",
        "obscureText": true,
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
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage;
        if (e.code == "user-not-found" || e.code == "wrong-password") {
          errorMessage = "Invalid email or password.";
        } else {
          errorMessage = e.message ?? "An unknown error occurred.";
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
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
              return TextField(
                controller: field["controller"],
                decoration: InputDecoration(
                  prefixIcon: Icon(_getIconData(field["iconName"])),
                  border: OutlineInputBorder(),
                  labelText: field["labelText"],
                ),
                obscureText: field["obscureText"],
              );
            }),
            FilledButton.icon(
              onPressed: signIn,
              icon: Icon(Symbols.login_rounded),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(double.infinity, 48),
              ),
              label: Text("Sign In"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Register()));
              },
              child: Text("Don't have an account? Register here."),
            ),
          ],
        ),
      ),
    );
  }
}
