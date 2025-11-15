import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/cards/profile_card.dart";
import "package:intellihire/components/lists/list_row.dart";
import "package:intellihire/pages/auth/login.dart";
import "package:intellihire/pages/profile/bookmarks.dart";
import "package:intellihire/pages/profile/edit_profile.dart";
import "package:intellihire/pages/profile/scores/my_scores.dart";
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

  static const _accountItems = [
    {"label": "My Scores", "iconName": "analytics"},
    {"label": "Change Password", "iconName": "lock"},
    {"label": "Bookmarks", "iconName": "bookmark"},
  ];

  static const _settingsItems = [
    {"label": "Settings", "iconName": "settings"},
  ];

  static const _supportItems = [
    {"label": "Help Center", "iconName": "help"},
    {"label": "About", "iconName": "info"},
    {"label": "Sign Out", "iconName": "logout"},
  ];

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case "bookmark":
        return Symbols.bookmark_rounded;
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

  Widget _buildStartIcon(String iconName, Color primaryColor) {
    return CircleAvatar(
      backgroundColor: primaryColor.withAlpha(38),
      child: Icon(_getIconData(iconName), color: primaryColor),
    );
  }

  Future<void> _handleSignOut() async {
    final navigator = Navigator.of(context);
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (context) => Login(themeController: widget.themeController),
      ),
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: const [CloseButton()],
      ),
    );
  }

  Widget _buildListGroup(String title, List<Map<String, dynamic>> items) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      spacing: 2,
      children: List.generate(items.length, (index) {
        final item = items[index];
        final label = item["label"] as String;
        final iconName = item["iconName"] as String;
        final startIcon = _buildStartIcon(iconName, primaryColor);

        Widget? navigateTo;
        VoidCallback? onClick;

        switch (label) {
          case "Bookmarks":
            navigateTo = const Bookmarks();
            break;
          case "My Scores":
            navigateTo = const MyScores();
            break;
          case "Settings":
            navigateTo = Settings(themeController: widget.themeController);
            break;
          case "Change Password":
            onClick = () {};
            break;
          case "Help Center":
            onClick = () => _showDialog(
              "Help Center",
              "Contact support at support@intellihire.com or visit our FAQ.",
            );
            break;
          case "About":
            onClick = () => _showDialog(
              "About IntelliHire",
              "IntelliHire: Smart Recruitment & Skill Assessment System.\nVersion 1.0",
            );
            break;
          case "Sign Out":
            onClick = _handleSignOut;
            break;
        }

        if (navigateTo != null) {
          return ListRow.navigate(
            title: index == 0 ? Text(title) : null,
            startIcon: startIcon,
            label: Text(label),
            navigateTo: navigateTo,
            first: index == 0,
            last: index == items.length - 1,
          );
        } else {
          return ListRow(
            title: index == 0 ? Text(title) : null,
            startIcon: startIcon,
            label: Text(label),
            onClick: onClick,
            first: index == 0,
            last: index == items.length - 1,
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const .symmetric(vertical: 16),
        child: Column(
          spacing: 12,
          children: [
            Padding(
              padding: const .all(12),
              child: ProfileCard(
                user: user,
                onEditPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ),
                  );
                },
              ),
            ),

            _buildListGroup("Account", _accountItems),
            _buildListGroup("Settings", _settingsItems),
            _buildListGroup("Support", _supportItems),
          ],
        ),
      ),
    );
  }
}
