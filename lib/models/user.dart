class User {
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String? profilePicture; 

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.profilePicture,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      profilePicture: map[''],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'profilePicture': profilePicture,
    };
  }
}
