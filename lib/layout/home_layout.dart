import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/navigation/navbar.dart";
import "package:intellihire/pages/home.dart";
import "package:intellihire/pages/jobs/jobs.dart";
import "package:intellihire/pages/profile/profile.dart";
import "package:intellihire/pages/tests/tests.dart";
import "package:intellihire/util/ui/theme_controller.dart";

class HomeLayout extends StatefulWidget {
  final String title;
  final ThemeController themeController;

  const HomeLayout({
    super.key,
    required this.title,
    required this.themeController,
  });

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _selectedIndex = 0;

  final List<String> _titles = const ["Home", "Jobs", "Tests", "Profile"];
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Home(),
      const Jobs(),
      const Tests(),
      Profile(themeController: widget.themeController),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        user: user,
      ),
    );
  }
}
