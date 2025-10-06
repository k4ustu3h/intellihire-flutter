import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/cards/profile_card.dart";
import "package:intellihire/components/core/list_row.dart";
import "package:intellihire/pages/auth/login.dart";
import "package:intellihire/pages/profile/edit_profile_page.dart";
import "package:intellihire/pages/profile/settings.dart";
import "package:intellihire/util/ui/theme_controller.dart";
import "package:material_symbols_icons/symbols.dart";

class Profile extends StatefulWidget {
  final ThemeController themeController;

  const Profile({super.key, required this.themeController});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;

  final List<Map<String, dynamic>> _accountItems = [
    {"label": "Settings", "iconName": "settings"},
    {"label": "My Scores", "iconName": "analytics"},
    {"label": "Change Password", "iconName": "lock"},
  ];

  final List<Map<String, dynamic>> _supportItems = [
    {"label": "Help Center", "iconName": "help"},
    {"label": "About", "iconName": "info"},
    {"label": "Sign Out", "iconName": "logout"},
  ];

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case "settings":
        return Symbols.settings_rounded;
      case "help":
        return Symbols.help_center_rounded;
      case "info":
        return Symbols.info_rounded;
      case "logout":
        return Symbols.logout_rounded;
      case "analytics":
        return Symbols.analytics_rounded;
      case "lock":
        return Symbols.lock_rounded;
      default:
        return Symbols.error;
    }
  }

  Widget _buildStartIcon(String iconName) {
    final theme = Theme.of(context).colorScheme;
    return CircleAvatar(
      backgroundColor: theme.primary,
      child: Icon(_getIconData(iconName), color: theme.onPrimary),
    );
  }

  void _handleMenuItemTap(Map<String, dynamic> item) async {
    final label = item["label"];

    if (label == "Settings") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SettingsPage(themeController: widget.themeController),
        ),
      );
    } else if (label == "My Scores" || label == "Change Password") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Navigating to $label...")));
    } else if (label == "About") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("About IntelliHire"),
          content: Text(
            "IntelliHire: Smart Recruitment & Skill Assessment System. Version 1.0",
          ),
          actions: [CloseButton()],
        ),
      );
    } else if (label == "Help Center") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Help Center"),
          content: Text(
            "Contact support at support@intellihire.com or visit our FAQ.",
          ),
          actions: [CloseButton()],
        ),
      );
    } else if (label == "Sign Out") {
      final navigator = Navigator.of(context);
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => Login(themeController: widget.themeController),
        ),
      );
    }
  }

  Widget _buildListGroup(List<Map<String, dynamic>> items) {
    return Column(
      spacing: 2,
      children: List.generate(items.length, (index) {
        final item = items[index];
        return ListRow(
          label: Text(
            item["label"] as String,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          startIcon: _buildStartIcon(item["iconName"] as String),
          endIcon: Icon(Symbols.navigate_next_rounded),

          first: index == 0,
          last: index == items.length - 1,

          onClick: () => _handleMenuItemTap(item),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 12,
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: ProfileCard(
                user: user,
                onEditPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
            ),

            _buildListGroup(_accountItems),
            _buildListGroup(_supportItems),
          ],
        ),
      ),
    );
  }
}
