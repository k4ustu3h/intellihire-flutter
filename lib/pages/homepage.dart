import "package:flutter/material.dart";
import "package:intellihire/components/navbar.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), toolbarHeight: 64),
      bottomNavigationBar: NavBar(selectedIndex: _selectedIndex),
    );
  }
}
