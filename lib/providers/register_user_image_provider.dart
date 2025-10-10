import 'package:flutter/material.dart';

class RegisterUserImageProvider with ChangeNotifier {
  String _imagePath = 'assets/images/user/default_profile.png';

  String get imagePath => _imagePath;

  void setImagePath(String newPath) {
    _imagePath = newPath;
    notifyListeners();
  }

  // Called after registration
  void resetImagePath() {
    _imagePath = 'assets/images/user/default_profile.png';
  }
}
