import 'package:crustascan_app/providers/register_user_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crustascan_app/services/auth_service.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  // Validates login inputs
  Future<bool> validateLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final bool loginSuccess = await _auth.login(context, email, password);

    if (!loginSuccess) {
      debugPrint('Login Unsuccessful');
      return false;
    }
    return true;
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

class RegisterController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  DateTime? selectedBirthday;
  String? selectedGender;
  String? selectedLocation;
  String? selectedRole;
  String? imagePath;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  String? termsError;
  bool agreedToTerms = false;

  bool validateRegister(BuildContext context) {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validate checkbox
    if (!agreedToTerms) {
      termsError = 'You must agree to the Terms and Privacy Policy.';
      return false;
    } else {
      termsError = null; // clear if valid
    }

    if (password.length < 8 &&
        !checkPasswordHasNumber(password) &&
        !checkPasswordHasUpperCase(password)) {
      // TODO: Handle error
      return false;
    }

    // Debug
    print(firstName);
    print(lastName);
    print(selectedBirthday);
    print(selectedGender);
    print(selectedLocation);
    print(selectedRole);
    print(email);
    print(password);
    print(confirmPassword);

    return true;
  }

  // KOBE: used for password validation
  bool checkPasswordHasUpperCase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

  bool checkPasswordHasNumber(String password) {
    return RegExp(r'[0-9]').hasMatch(password);
  }

  // Function to submit the data to firebase
  Future<bool> submitRegistration(context) async {
    final registerUserImageProvider = Provider.of<RegisterUserImageProvider>(
      context,
      listen: false,
    );
    return await _authService.registerUser(
      email: emailController.text.trim(),
      password: passwordController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      username: usernameController.text,
      birthday: selectedBirthday?.toIso8601String(),
      gender: selectedGender,
      location: selectedLocation,
      role: selectedRole,
      imagePath: registerUserImageProvider.imagePath,
    );
  }

  //Bug Fix
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
