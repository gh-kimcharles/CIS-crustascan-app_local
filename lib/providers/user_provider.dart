import 'package:crustascan_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:crustascan_app/models/user_model.dart';

class UserProvider with ChangeNotifier {
  late User _user;

  UserProvider() {
    _user = User(
      imagePath: 'assets/images/user/default_profile.png',
      firstName: '',
      lastName: '',
      birthday: '',
      gender: '',
      location: '',
      role: '',
      email: '',
      username: '',
      favorites: [],
      history: [],
    );
  }

  User get user => _user;

  List<String> get favorites => _user.favorites;

  bool isFavorite(String speciesId) => _user.favorites.contains(speciesId);

  void updateUser(BuildContext context, User newUser) {
    _user = newUser;
    // AuthService().updateUser(newUser);
    notifyListeners();
  }

  Future<void> updateProfileImage(String imagePath) async {
    try {
      // Upload image and get new URL
      final String newImageLink = await AuthService().uploadProfileImage(
        imagePath,
      );

      // Add cache-busting timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final cacheBustedUrl = '$newImageLink?t=$timestamp';

      // Update local user object with cache-busted URL
      _user = _user.copyWith(imagePath: cacheBustedUrl);

      // Notify listeners to rebuild UI
      notifyListeners();

      // Update backend with ORIGINAL URL (no timestamp)
      final userForBackend = _user.copyWith(imagePath: newImageLink);
      await AuthService().updateUserProfile(userForBackend);

      debugPrint('Profile updated on backend with: $newImageLink');
    } catch (e) {
      debugPrint('Error updating profile image: $e');
      rethrow;
    }
  }

  void toggleFavorite(String speciesId) async {
    final oldFavorites = List<String>.from(_user.favorites);

    if (_user.favorites.contains(speciesId)) {
      _user.favorites.remove(speciesId);
    } else {
      _user.favorites.add(speciesId);
    }
    notifyListeners();

    try {
      await AuthService().toggleFavorite(speciesId);
      debugPrint('Favorite toggled: $speciesId');
    } catch (e) {
      _user = _user.copyWith(favorites: oldFavorites);
      notifyListeners();
      debugPrint('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Only notify listeners - update logic is handled by the controller.
  void notifyUpdate() {
    notifyListeners();
  }

  User getUser() {
    return _user;
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': _user.imagePath,
      'firstName': _user.firstName,
      'lastName': _user.lastName,
      'birthday': _user.birthday,
      'gender': _user.gender,
      'location': _user.location,
      'role': _user.role,
      'email': _user.email,
      'username': _user.username,
      'favorites': _user.favorites,
    };
  }

  Future<void> resetUser(BuildContext context) async {
    // Sync favorites and history to backend before logout
    // await AuthService().updateUser(_user);
    // await AuthService().uploadHistory(_user.history);

    // Logout - just clear local data
    await AuthService().logout();

    // reset
    _user = User(
      imagePath: 'assets/images/user/default_profile.png',
      firstName: '',
      lastName: '',
      birthday: '',
      gender: '',
      location: '',
      role: '',
      email: '',
      username: '',
      favorites: [],
      history: [],
    );
    notifyListeners();
  }
}
