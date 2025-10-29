import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intellihire/pages/profile/bookmarks.dart";
import "package:intellihire/services/user_service.dart";

class BookmarkHelper {
  static final UserService _userService = UserService();

  static Future<bool> isBookmarked(String jobId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    return _userService.isJobBookmarked(user.uid, jobId);
  }

  static Future<bool> toggleBookmark({
    required BuildContext context,
    required String jobId,
    required bool isCurrentlyBookmarked,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please log in to bookmark jobs.")),
        );
      }
      return isCurrentlyBookmarked;
    }

    try {
      if (isCurrentlyBookmarked) {
        await _userService.removeBookmark(user.uid, jobId);
      } else {
        await _userService.addBookmark(user.uid, jobId);
      }

      if (!context.mounted) return isCurrentlyBookmarked;

      final snackBar = SnackBar(
        content: Text(
          isCurrentlyBookmarked
              ? "Job removed from bookmarks."
              : "Job saved to bookmarks.",
        ),
        action: !isCurrentlyBookmarked
            ? SnackBarAction(
                label: "View Bookmarks",
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const Bookmarks()));
                },
              )
            : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return !isCurrentlyBookmarked;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error updating bookmark: $e")));
      }
      return isCurrentlyBookmarked;
    }
  }
}
