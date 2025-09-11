import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class ProfileAvatar extends StatelessWidget {
  final double radius;

  const ProfileAvatar({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl = user?.photoURL;
    final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

    return CircleAvatar(
      backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
      radius: radius,
      child: !hasPhoto ? Icon(Icons.person, size: radius) : null,
    );
  }
}
