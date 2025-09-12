import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";

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
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
