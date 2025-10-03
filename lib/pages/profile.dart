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

  final List<Map<String, dynamic>> _menuItems = [
    {"label": "Settings", "iconName": "settings", "first": true, "last": false},
    {"label": "Sign Out", "iconName": "logout", "first": false, "last": true},
  ];

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case "settings":
        return Symbols.settings_rounded;
      case "logout":
        return Symbols.logout_rounded;
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
    if (item["label"] == "Settings") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SettingsPage(themeController: widget.themeController),
        ),
      );
    } else if (item["label"] == "Sign Out") {
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
            Column(
              spacing: 2,
              children: [
                ..._menuItems.map((item) {
                  return ListRow(
                    label: Text(item["label"], style: textTheme.titleMedium),
                    startIcon: _buildStartIcon(item["iconName"]),
                    endIcon: Icon(Symbols.navigate_next_rounded),
                    first: item["first"],
                    last: item["last"],
                    onClick: () => _handleMenuItemTap(item),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
