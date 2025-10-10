import 'package:flutter/material.dart';
import '../models/guest_model.dart';

class GuestProvider with ChangeNotifier {
  Guest? _guest;

  bool get isGuest => _guest != null;

  Guest? get guest => _guest;

  void loginAsGuest() {
    _guest = Guest(
      imagePath: 'assets/images/user/default_profile.png',
      firstName: 'Guest',
      lastName: '',
    );
    notifyListeners();
  }

  void logoutGuest() {
    _guest = null;
    notifyListeners();
  }
}
