import "package:flutter/material.dart";
import "package:intellihire/components/navbar.dart";
import "package:intellihire/components/profile_avatar.dart";
import "package:intellihire/components/top_app_bar.dart";
import "package:intellihire/pages/jobs.dart";
import "package:intellihire/pages/profile.dart";

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[Text(""), Jobs(), Text("")];

  static final List<String> _titles = <String>["Home", "Jobs", "Tests"];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        title: _titles[_selectedIndex],
        actions: [
          Padding(
            padding: EdgeInsets.all(4),
            child: IconButton(
              icon: ProfileAvatar(radius: 16),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
            ),
          ),
        ],
      ),
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}
