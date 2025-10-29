class UserProfile {
  final String uid;
  final List<String> bookmarks;
  final String firstName;
  final String lastName;
  final String city;
  final String state;
  final String phoneNumber;

  const UserProfile({
    required this.uid,
    this.bookmarks = const [],
    this.firstName = "",
    this.lastName = "",
    this.city = "",
    this.state = "",
    this.phoneNumber = "",
  });

  Map<String, dynamic> toMap() => {
    "bookmarkedJobs": bookmarks,
    "firstName": firstName,
    "lastName": lastName,
    "city": city,
    "state": state,
    "phoneNumber": phoneNumber,
  };

  factory UserProfile.fromMap(Map<String, dynamic> data, String uid) {
    return UserProfile(
      uid: uid,
      bookmarks: List<String>.from(data["bookmarkedJobs"] ?? []),
      firstName: data["firstName"] as String? ?? "",
      lastName: data["lastName"] as String? ?? "",
      city: data["city"] as String? ?? "",
      state: data["state"] as String? ?? "",
      phoneNumber: data["phoneNumber"] as String? ?? "",
    );
  }
}
