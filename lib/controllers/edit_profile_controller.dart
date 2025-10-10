import 'package:crustascan_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:crustascan_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfileController {
  final newFirstNameController = TextEditingController();
  final newLastNameController = TextEditingController();
  final newEmailController = TextEditingController();
  final newUsernameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  bool validateSaveChanges(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final newFirstName = newFirstNameController.text.trim();
    final newLastName = newLastNameController.text.trim();
    final newEmail = newEmailController.text.trim();
    final newUsername = newUsernameController.text.trim();

    final hasChanges =
        (newFirstName.isNotEmpty && newFirstName != user.firstName) ||
        (newLastName.isNotEmpty && newLastName != user.lastName) ||
        (newEmail.isNotEmpty && newEmail != user.email) ||
        (newUsername.isNotEmpty && newUsername != user.username);

    return hasChanges;
  }

  /// Move update logic here
  Future<void> applyChanges(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;

    final updatedUser = currentUser.copyWith(
      firstName: newFirstNameController.text.trim().isNotEmpty
          ? newFirstNameController.text.trim()
          : null,
      lastName: newLastNameController.text.trim().isNotEmpty
          ? newLastNameController.text.trim()
          : null,
      email: newEmailController.text.trim().isNotEmpty
          ? newEmailController.text.trim()
          : null,
      username: newUsernameController.text.trim().isNotEmpty
          ? newUsernameController.text.trim()
          : null,
    );

    // Update backend FIRST before updating UI
    try {
      final success = await AuthService().updateUserProfile(updatedUser);

      if (success) {
        userProvider.updateUser(context, updatedUser);

        // Clear controllers after successful update
        newFirstNameController.clear();
        newLastNameController.clear();
        newUsernameController.clear();
        newEmailController.clear();

        debugPrint('Profile updated successfully');
      } else {
        throw Exception('Backend update failed');
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      // Propagate error so UI can show error message
      rethrow;
    }
  }

  Future<bool> validateChangePassword(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmNewPasswordController.text.trim();

    try {
      bool successful = await AuthService().updatePassword(
        oldPassword,
        newPassword,
      );
      return successful;
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    newFirstNameController.dispose();
    newLastNameController.dispose();
    newEmailController.dispose();
    newUsernameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
  }
}
