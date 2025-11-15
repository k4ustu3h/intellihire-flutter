import "package:cloud_firestore/cloud_firestore.dart";
import "package:intellihire/models/user_profile.dart";

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile> getUserProfile(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return .fromMap(doc.data()!, uid);
    }
    return UserProfile(uid: uid);
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _firestore
        .collection("users")
        .doc(profile.uid)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  Future<void> addBookmark(String uid, String jobId) async {
    await _firestore.collection("users").doc(uid).set({
      "bookmarkedJobs": FieldValue.arrayUnion([jobId]),
    }, SetOptions(merge: true));
  }

  Future<void> removeBookmark(String uid, String jobId) async {
    await _firestore.collection("users").doc(uid).set({
      "bookmarkedJobs": FieldValue.arrayRemove([jobId]),
    }, SetOptions(merge: true));
  }

  Future<List<String>> getBookmarkedJobs(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    final data = doc.data();
    return List<String>.from(data?["bookmarkedJobs"] ?? []);
  }

  Future<bool> isJobBookmarked(String uid, String jobId) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    final data = doc.data();
    final bookmarks = List<String>.from(data?["bookmarkedJobs"] ?? []);
    return bookmarks.contains(jobId);
  }

  Future<void> toggleBookmark(String uid, String jobId) async {
    final userRef = _firestore.collection("users").doc(uid);
    final snapshot = await userRef.get();
    final bookmarks = List<String>.from(
      snapshot.data()?["bookmarkedJobs"] ?? [],
    );

    if (bookmarks.contains(jobId)) {
      bookmarks.remove(jobId);
    } else {
      bookmarks.add(jobId);
    }

    await userRef.set({"bookmarkedJobs": bookmarks}, SetOptions(merge: true));
  }
}
