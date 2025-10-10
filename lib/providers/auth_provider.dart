import 'package:flutter/material.dart';

enum AuthState { none, guest, user }

class AuthProvider with ChangeNotifier {
  AuthState _authState = AuthState.none;

  // Getters
  AuthState get authState => _authState;
  bool get isAuthenticated => _authState == AuthState.user;
  bool get isGuest => _authState == AuthState.guest;
  bool get isUser => _authState == AuthState.user;

  // Authentication state management
  void loginAsGuest() {
    _authState = AuthState.guest;
    notifyListeners();
  }

  void loginAsUser() {
    _authState = AuthState.user;
    notifyListeners();
  }

  // Logout
  void logout() {
    _authState = AuthState.none;
    notifyListeners();
  }
}
