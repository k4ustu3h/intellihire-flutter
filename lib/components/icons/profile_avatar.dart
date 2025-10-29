import "package:cached_network_image/cached_network_image.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";

class ProfileAvatar extends StatelessWidget {
  final double radius;

  final ImageProvider? backgroundImage;

  const ProfileAvatar({super.key, required this.radius, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl = user?.photoURL;
    final hasAuthPhoto = photoUrl != null && photoUrl.isNotEmpty;

    final ImageProvider? finalImageProvider =
        backgroundImage ??
        (hasAuthPhoto ? CachedNetworkImageProvider(photoUrl) : null);

    final bool hasFinalImage = finalImageProvider != null;

    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      backgroundImage: finalImageProvider,
      radius: radius,
      child: !hasFinalImage
          ? Icon(Symbols.person_rounded, fill: 1, size: radius)
          : null,
    );
  }
}
