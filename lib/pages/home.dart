import "package:flutter/material.dart";
import "package:intellihire/components/navbar.dart";
import "package:intellihire/components/profile_avatar.dart";
import "package:intellihire/components/top_app_bar.dart";
import "package:intellihire/pages/profile.dart";

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
      appBar: TopAppBar(
        title: widget.title,
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
      bottomNavigationBar: NavBar(selectedIndex: _selectedIndex),
    );
  }
}
