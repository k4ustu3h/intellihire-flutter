import "package:easy_localization/easy_localization.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:heroine/heroine.dart";
import "package:intellihire/components/icons/profile_avatar.dart";
import "package:material_symbols_icons/symbols.dart";

class ProfileCard extends StatelessWidget {
  final User? user;
  final VoidCallback onEditPressed;

  const ProfileCard({
    super.key,
    required this.user,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            const Heroine(
              tag: "profile-avatar-hero",
              child: ProfileAvatar(radius: 32),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    user?.displayName ?? "not_available".tr(),
                    style: textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user?.email ?? "not_available".tr(),
                    style: textTheme.bodyLarge!.copyWith(
                      color: theme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Symbols.edit_rounded, size: 24),
              onPressed: onEditPressed,
              tooltip: "edit_profile".tr(),
            ),
          ],
        ),
      ),
    );
  }
}
