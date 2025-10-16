import "package:easy_localization/easy_localization.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/icons/profile_avatar.dart";
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
          icon: const Icon(Symbols.home_rounded),
          label: "home".tr(),
          selectedIcon: const Icon(Symbols.home_rounded, fill: 1),
        ),
        NavigationDestination(
          icon: const Icon(Symbols.work_rounded),
          label: "jobs".tr(),
          selectedIcon: const Icon(Symbols.work_rounded, fill: 1),
        ),
        NavigationDestination(
          icon: const Icon(Symbols.checklist_rounded),
          label: "tests".tr(),
          selectedIcon: const Icon(Symbols.checklist_rounded, fill: 1),
        ),
        NavigationDestination(
          icon: const ProfileAvatar(radius: 12),
          label: "profile".tr(),
          selectedIcon: const ProfileAvatar(radius: 12),
        ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
