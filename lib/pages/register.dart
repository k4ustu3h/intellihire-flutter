import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/pages/login.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:simple_icons/simple_icons.dart";

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final List<Map<String, dynamic>> _fields;

  @override
  void initState() {
    super.initState();
    _fields = [
      {
        "controller": _nameController,
        "labelText": "Name",
        "iconName": "name",
        "obscureText": false,
      },
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

  final List<Map<String, dynamic>> _buttons = [
    {"label": "Continue with Google", "iconName": "google"},
    {"label": "Continue with Apple", "iconName": "apple"},
  ];

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case "apple":
        return SimpleIcons.apple;
      case "email":
        return Symbols.email_rounded;
      case "name":
        return Symbols.person_rounded;
      case "google":
        return SimpleIcons.google;
      case "password":
        return Symbols.password;
      default:
        return Symbols.error;
    }
  }

  Future<void> signUp() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      if (mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == "weak-password") {
        errorMessage = "The password provided is too weak.";
      } else if (e.code == "email-already-in-use") {
        errorMessage = "An account already exists for that email.";
      } else {
        errorMessage = e.message ?? "An unknown error occurred.";
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
            Text("Create an Account", style: textTheme.displaySmall),
            Text("Enter your details", style: textTheme.titleMedium),
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
            FilledButton(
              onPressed: signUp,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text("Sign Up"),
            ),
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Or", style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            ..._buttons.map((button) {
              return FilledButton.icon(
                onPressed: () {},
                icon: Icon(_getIconData(button["iconName"])),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(double.infinity, 48),
                ),
                label: Text(button["label"]),
              );
            }),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text("Already have an account? Login here."),
            ),
          ],
        ),
      ),
    );
  }
}
