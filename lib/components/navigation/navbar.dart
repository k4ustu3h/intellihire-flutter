import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/profile_avatar.dart";
import "package:material_symbols_icons/symbols.dart";

class NavBar extends StatelessWidget {
  final int selectedIndex;

  final Function(int)? onDestinationSelected;
  final User? user;

  const NavBar({
    super.key,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: <Widget>[
        NavigationDestination(
          icon: Icon(Symbols.home_rounded),
          label: "Home",
          selectedIcon: Icon(Symbols.home_rounded, fill: 1),
        ),
        NavigationDestination(
          icon: Icon(Symbols.work_rounded),
          label: "Jobs",
          selectedIcon: Icon(Symbols.work_rounded, fill: 1),
        ),
        NavigationDestination(
          icon: Icon(Symbols.checklist_rounded),
          label: "Tests",
          selectedIcon: Icon(Symbols.checklist_rounded, fill: 1),
        ),
        NavigationDestination(
          icon: ProfileAvatar(radius: 12),
          label: "Profile",
          selectedIcon: ProfileAvatar(radius: 12),
        ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
