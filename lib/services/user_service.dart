import "package:cloud_firestore/cloud_firestore.dart";
import "package:intellihire/models/user_profile.dart";

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile> getUserProfile(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserProfile.fromMap(doc.data()!, uid);
    }
    return UserProfile(uid: uid);
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _firestore
        .collection("users")
        .doc(profile.uid)
        .set(profile.toMap(), SetOptions(merge: true));
  }
}
