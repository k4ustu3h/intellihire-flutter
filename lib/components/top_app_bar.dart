import "package:flutter/material.dart";

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const TopAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), toolbarHeight: 64, actions: actions);
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
