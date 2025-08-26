import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/pages/register_page.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
                obscureText: true,
              ),
            ),
            FilledButton(onPressed: signIn, child: const Text("Sign In")),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text("Don't have an account? Register here."),
            ),
          ],
        ),
      ),
    );
  }
}
