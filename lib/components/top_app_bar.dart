import "package:flutter/material.dart";

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), toolbarHeight: 64);
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
