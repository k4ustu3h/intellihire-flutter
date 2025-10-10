import "package:flutter/material.dart";

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Padding>? actions;
  final String title;

  const TopAppBar({super.key, this.actions, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(actions: actions, toolbarHeight: 64, title: Text(title));
  }

  @override
  Size get preferredSize => Size.fromHeight(64);
}
