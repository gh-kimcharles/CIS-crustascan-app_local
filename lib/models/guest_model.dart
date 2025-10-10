class Guest {
  String imagePath;
  String firstName;
  String lastName;

  Guest({
    required this.imagePath,
    required this.firstName,
    required this.lastName,
  });

  Guest copyWith({String? imagePath, String? firstName, String? lastName}) {
    return Guest(
      imagePath: imagePath ?? this.imagePath,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
