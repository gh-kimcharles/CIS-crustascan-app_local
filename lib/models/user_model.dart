import 'package:crustascan_app/models/history_model.dart';

class User {
  String imagePath;
  String firstName;
  String lastName;
  String birthday;
  String gender;
  String location;
  String role;
  String email;
  String username;
  List<String> favorites;
  List<History> history;

  User({
    required this.imagePath,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.location,
    required this.role,
    required this.email,
    required this.username,
    this.favorites = const [],
    this.history = const [],
  });

  User copyWith({
    String? imagePath,
    String? firstName,
    String? lastName,
    String? birthday,
    String? gender,
    String? location,
    String? role,
    String? email,
    String? username,
    List<String>? favorites,
    List<History>? history,
  }) {
    return User(
      imagePath: imagePath ?? this.imagePath,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      role: role ?? this.role,
      email: email ?? this.email,
      username: username ?? this.username,
      favorites: favorites ?? List.from(this.favorites),
      history: history ?? List.from(this.history),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday,
      'gender': gender,
      'location': location,
      'role': role,
      'email': email,
      'username': username,
      'favorites': favorites,
      'history': history.map((h) => h.toMap()).toList(),
    };
  }
}
