import "dart:io";

import "package:expressive_loading_indicator/expressive_loading_indicator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:intellihire/components/profile_avatar.dart";
import "package:intellihire/models/user_profile.dart";
import "package:intellihire/services/user_service.dart";
import "package:material_symbols_icons/symbols.dart";

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _user = FirebaseAuth.instance.currentUser!;
  final _userService = UserService();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isPhotoUploading = false;

  File? _newImageFile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final profile = await _userService.getUserProfile(_user.uid);

    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _cityController.text = profile.city;
    _stateController.text = profile.state;
    _phoneNumberController.text = _user.phoneNumber ?? "";
    _emailController.text = _user.email ?? "";

    if (_user.displayName != null &&
        _user.displayName!.isNotEmpty &&
        profile.firstName.isEmpty) {
      final names = _user.displayName!.split(" ");
      _firstNameController.text = names.isNotEmpty ? names.first : "";
      _lastNameController.text = names.length > 1
          ? names.sublist(1).join(" ")
          : "";
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    setState(() {
      _isPhotoUploading = true;
      _newImageFile = File(pickedFile.path);
    });

    try {
      final ref = FirebaseStorage.instance.ref(
        "user_profile_photos/${_user.uid}/profile.jpg",
      );

      await ref.putFile(_newImageFile!);
      final downloadUrl = await ref.getDownloadURL();
      await _user.updatePhotoURL(downloadUrl);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Profile photo updated.")));
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Photo upload failed: ${e.message}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPhotoUploading = false;
          _newImageFile = null;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final updatedProfile = UserProfile(
      uid: _user.uid,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
    );

    final newDisplayName =
        "${updatedProfile.firstName} ${updatedProfile.lastName}".trim();

    try {
      if (_user.displayName != newDisplayName) {
        await _user.updateDisplayName(newDisplayName);
      }

      await _userService.updateProfile(updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Profile saved successfully!")));
        Navigator.pop(context);
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Save failed: ${e.message}")));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool enabled = true,
    bool requiredField = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(),
          enabled: enabled,
        ),
        validator: (value) {
          if (requiredField && enabled && (value == null || value.isEmpty)) {
            return "$label cannot be empty";
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Edit Profile")),
        body: Center(child: ExpressiveLoadingIndicator()),
      );
    }

    final isBusy = _isSaving || _isPhotoUploading;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              icon: Icon(Symbols.save_rounded),
              label: Text("Save Profile"),
              onPressed: isBusy ? null : _saveProfile,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Stack(
                    children: [
                      ProfileAvatar(radius: 60),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: _isPhotoUploading
                            ? ExpressiveLoadingIndicator()
                            : IconButton(
                                icon: Icon(Symbols.photo_camera_rounded),
                                onPressed: _pickAndUploadImage,
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      theme.colorScheme.surfaceVariant,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildTextField(
                controller: _firstNameController,
                label: "First Name",
                icon: Symbols.person_rounded,
              ),
              _buildTextField(
                controller: _lastNameController,
                label: "Last Name",
                icon: Symbols.person_rounded,
              ),
              _buildTextField(
                controller: _cityController,
                label: "City",
                icon: Symbols.location_city_rounded,
              ),
              _buildTextField(
                controller: _stateController,
                label: "State/Region",
                icon: Symbols.location_on_rounded,
              ),
              Divider(height: 32),
              _buildTextField(
                controller: _phoneNumberController,
                label: "Phone Number",
                icon: Symbols.phone_rounded,
              ),
              _buildTextField(
                controller: _emailController,
                label: "Email (Read-Only)",
                icon: Symbols.email_rounded,
                enabled: false,
                requiredField: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
