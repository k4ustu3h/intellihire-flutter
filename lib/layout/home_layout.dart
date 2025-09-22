import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/navbar.dart";
import "package:intellihire/components/top_app_bar.dart";
import "package:intellihire/pages/jobs.dart";
import "package:intellihire/pages/profile.dart";

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key, required this.title});

  final String title;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    Text(""),
    Jobs(),
    Text(""),
    Profile(),
  ];

  static final List<String> _titles = <String>[
    "Home",
    "Jobs",
    "Tests",
    "Profile",
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: TopAppBar(title: _titles[_selectedIndex]),
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        user: user,
      ),
    );
  }
}
