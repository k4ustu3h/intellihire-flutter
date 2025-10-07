import "dart:io";

import "package:expressive_loading_indicator/expressive_loading_indicator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:intellihire/components/menus/city_dropdown.dart";
import "package:intellihire/components/menus/state_dropdown.dart";
import "package:intellihire/components/profile_avatar.dart";
import "package:intellihire/components/textfields/profile_field.dart";
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

  String? _selectedState;
  String? _selectedCity;

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

    if (_user.displayName?.isNotEmpty == true && profile.firstName.isEmpty) {
      final names = _user.displayName!.split(" ");
      _firstNameController.text = names.first;
      _lastNameController.text = names.skip(1).join(" ");
    }

    _selectedState = profile.state.isNotEmpty ? profile.state : null;
    _selectedCity = profile.city.isNotEmpty ? profile.city : null;

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

    if (_selectedState == null || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both State and City.")),
      );
      return;
    }

    setState(() => _isSaving = true);

    final updatedProfile = UserProfile(
      uid: _user.uid,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      city: _selectedCity!,
      state: _selectedState!,
      phoneNumber: _phoneNumberController.text.trim(),
    );

    final displayName = "${updatedProfile.firstName} ${updatedProfile.lastName}"
        .trim();

    try {
      if (_user.displayName != displayName) {
        await _user.updateDisplayName(displayName);
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

  Widget _buildFormSection(bool isBusy) {
    if (_isLoading) return Center(child: ExpressiveLoadingIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileField(
          controller: _firstNameController,
          label: "First Name",
          icon: Symbols.person_rounded,
          enabled: !isBusy,
        ),
        ProfileField(
          controller: _lastNameController,
          label: "Last Name",
          icon: Symbols.person_rounded,
          enabled: !isBusy,
        ),

        StateDropdown(
          selectedState: _selectedState,
          onChanged: (value) {
            setState(() {
              _selectedState = value;
              _stateController.text = value ?? "";
              _selectedCity = null;
              _cityController.text = "";
            });
          },
          enabled: !isBusy,
        ),
        CityDropdown(
          selectedState: _selectedState,
          selectedCity: _selectedCity,
          onChanged: (value) {
            setState(() {
              _selectedCity = value;
              _cityController.text = value ?? "";
            });
          },
          enabled: _selectedState != null && !isBusy,
        ),

        Divider(height: 32),

        ProfileField(
          controller: _phoneNumberController,
          label: "Phone Number",
          icon: Symbols.phone_rounded,
          keyboardType: TextInputType.phone,
          enabled: !isBusy,
        ),
        ProfileField(
          controller: _emailController,
          label: "Email (Read-Only)",
          icon: Symbols.email_rounded,
          enabled: false,
          requiredField: false,
        ),
      ],
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
              onPressed: isBusy || _isLoading ? null : _saveProfile,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16),
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
                                onPressed: isBusy ? null : _pickAndUploadImage,
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
              _buildFormSection(isBusy),
            ],
          ),
        ),
      ),
    );
  }
}
