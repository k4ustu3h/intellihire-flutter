import "package:flutter/material.dart";
import "package:intellihire/components/navbar.dart";

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), toolbarHeight: 64),
      bottomNavigationBar: NavBar(selectedIndex: _selectedIndex),
    );
  }
}
