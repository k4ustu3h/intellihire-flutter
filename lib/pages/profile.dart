import "dart:io";

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:intellihire/components/profile_avatar.dart";
import "package:intellihire/pages/login.dart";
import "package:material_symbols_icons/symbols.dart";

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  bool _isUploading = false;

  final List<Map<String, dynamic>> _menuItems = [
    {"label": "Settings", "iconName": "settings"},
    {"label": "Sign Out", "iconName": "logout"},
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

    setState(() {
      _isUploading = true;
    });

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
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              Card.outlined(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Row(
                    children: [
                      if (_isUploading)
                        CircularProgressIndicator()
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
              ..._menuItems.map((item) {
                return InkWell(
                  onTap: () async {
                    if (item["label"] == "Settings") {
                    } else if (item["label"] == "Sign Out") {
                      final navigator = Navigator.of(context);
                      await FirebaseAuth.instance.signOut();

                      if (!mounted) return;

                      navigator.pushReplacement(
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Card.filled(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          color: theme.primary,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              _getIconData(item["iconName"]),
                              weight: 400,
                              size: 24,
                              color: theme.onPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              item["label"],
                              style: textTheme.titleLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
