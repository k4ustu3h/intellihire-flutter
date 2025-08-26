import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
                obscureText: true,
              ),
            ),
            FilledButton(onPressed: signUp, child: const Text("Sign Up")),
          ],
        ),
      ),
    );
  }
}
