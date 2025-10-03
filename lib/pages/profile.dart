import "dart:io";

import "package:expressive_loading_indicator/expressive_loading_indicator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:intellihire/components/core/list_row.dart";
import "package:intellihire/components/profile_avatar.dart";
import "package:intellihire/pages/auth/login.dart";
import "package:intellihire/pages/settings.dart";
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
  bool _isUploading = false;

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

  Future<void> _pickAndUploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User is not authenticated. Please log in again."),
          ),
        );
      }
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() => _isUploading = true);

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("user_profile_photos")
          .child(user.uid)
          .child("profile.jpg");

      final file = File(pickedFile.path);
      await storageRef.putFile(file);

      final downloadUrl = await storageRef.getDownloadURL();
      await user.updatePhotoURL(downloadUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile photo updated successfully!")),
        );
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update photo: ${e.message}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
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
    } else if (label == "My Scores") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Navigating to My Scores (Analytics Page)...")),
      );
    } else if (label == "Change Password") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Opening Change Password dialog...")),
      );
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
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          spacing: 12,
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Card.outlined(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Row(
                    children: [
                      if (_isUploading)
                        ExpressiveLoadingIndicator()
                      else
                        Stack(
                          children: [
                            ProfileAvatar(radius: 48),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: theme.surfaceContainer,
                                ),
                                icon: Icon(Symbols.photo_camera_rounded),
                                onPressed: _pickAndUploadImage,
                              ),
                            ),
                          ],
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              user?.displayName ?? "Not available",
                              style: textTheme.titleLarge,
                            ),
                            Text(
                              user?.email ?? "Not available",
                              style: textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
