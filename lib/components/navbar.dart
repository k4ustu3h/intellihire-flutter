import "package:flutter/material.dart";

class NavBar extends StatelessWidget {
  final int selectedIndex;

  final Function(int)? onDestinationSelected;

  const NavBar({
    super.key,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: "Home",
          selectedIcon: Icon(Icons.home_rounded),
        ),
        NavigationDestination(
          icon: Icon(Icons.work_outline_rounded),
          label: "Jobs",
          selectedIcon: Icon(Icons.work_rounded),
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          label: "Settings",
          selectedIcon: Icon(Icons.settings_rounded),
        ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
