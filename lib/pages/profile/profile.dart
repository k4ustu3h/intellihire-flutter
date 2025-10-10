import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/components/cards/profile_card.dart";
import "package:intellihire/components/lists/list_row.dart";
import "package:intellihire/pages/auth/login.dart";
import "package:intellihire/pages/profile/edit_profile_page.dart";
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

  final List<Map<String, dynamic>> _accountItems = [
    {"label": "My Scores", "iconName": "analytics"},
    {"label": "Change Password", "iconName": "lock"},
  ];

  final List<Map<String, dynamic>> _settingsItems = [
    {"label": "Settings", "iconName": "settings"},
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
      backgroundColor: theme.primary.withValues(alpha: 0.15),
      child: Icon(_getIconData(iconName), color: theme.primary),
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
        actions: [CloseButton()],
      ),
    );
  }

  Widget _buildListGroup(String title, List<Map<String, dynamic>> items) {
    return Column(
      spacing: 2,
      children: List.generate(items.length, (index) {
        final item = items[index];
        final label = item["label"] as String;
        final iconName = item["iconName"] as String;

        switch (label) {
          case "My Scores":
            return ListRow.navigate(
              title: index == 0 ? Text(title) : null,
              startIcon: _buildStartIcon(iconName),
              label: Text(label),
              navigateTo: MyScores(),
              first: index == 0,
              last: index == items.length - 1,
            );

          case "Settings":
            return ListRow.navigate(
              title: index == 0 ? Text(title) : null,
              startIcon: _buildStartIcon(iconName),
              label: Text(label),
              navigateTo: SettingsPage(themeController: widget.themeController),
              first: index == 0,
              last: index == items.length - 1,
            );

          case "Change Password":
            return ListRow(
              title: index == 0 ? Text(title) : null,
              startIcon: _buildStartIcon(iconName),
              label: Text(label),
              onClick: () {},
              first: index == 0,
              last: index == items.length - 1,
            );

          case "Help Center":
            return ListRow(
              title: index == 0 ? Text(title) : null,
              startIcon: _buildStartIcon(iconName),
              label: Text(label),
              onClick: () => _showDialog(
                "Help Center",
                "Contact support at support@intellihire.com or visit our FAQ.",
              ),
              first: index == 0,
              last: index == items.length - 1,
            );

          case "About":
            return ListRow(
              title: index == 0 ? Text(title) : null,
              startIcon: _buildStartIcon(iconName),
              label: Text(label),
              onClick: () => _showDialog(
                "About IntelliHire",
                "IntelliHire: Smart Recruitment & Skill Assessment System.\nVersion 1.0",
              ),
              first: index == 0,
              last: index == items.length - 1,
            );

          case "Sign Out":
            return ListRow(
              title: index == 0 ? Text(title) : null,
              startIcon: _buildStartIcon(iconName),
              label: Text(label),
              onClick: _handleSignOut,
              first: index == 0,
              last: index == items.length - 1,
            );

          default:
            return SizedBox.shrink();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
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

            _buildListGroup("Account", _accountItems),
            _buildListGroup("Settings", _settingsItems),
            _buildListGroup("Support", _supportItems),
          ],
        ),
      ),
    );
  }
}
