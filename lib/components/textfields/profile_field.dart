import "package:flutter/material.dart";

class ProfileField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final bool enabled;
  final bool requiredField;
  final TextInputType keyboardType;

  const ProfileField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.enabled = true,
    this.requiredField = true,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: const OutlineInputBorder(),
          enabled: enabled,
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (requiredField && enabled && (value == null || value.isEmpty)) {
            return "$label cannot be empty";
          }
          return null;
        },
      ),
    );
  }
}
