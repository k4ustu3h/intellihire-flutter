class UserProfile {
  final String uid;
  final String firstName;
  final String lastName;
  final String city;
  final String state;
  final String phoneNumber;

  UserProfile({
    required this.uid,
    this.firstName = "",
    this.lastName = "",
    this.city = "",
    this.state = "",
    this.phoneNumber = "",
  });

  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "city": city,
      "state": state,
      "phoneNumber": phoneNumber,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> data, String uid) {
    return UserProfile(
      uid: uid,
      firstName: data["firstName"] ?? "",
      lastName: data["lastName"] ?? "",
      city: data["city"] ?? "",
      state: data["state"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
    );
  }
}
