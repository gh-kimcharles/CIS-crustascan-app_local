import 'package:crustascan_app/controllers/edit_profile_controller.dart';
import 'package:crustascan_app/services/auth_service.dart';
import 'package:crustascan_app/utils/helpers/connectivity_helper.dart';
import 'package:crustascan_app/views/pages/profile/edit_profile_page.dart';
import 'package:crustascan_app/views/pages/profile/profile_page.dart';
import 'package:crustascan_app/views/pages/profile/widgets/custom_change_password_form_field.dart';
import 'package:crustascan_app/views/pages/profile/widgets/custom_edit_profile_button.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool oldPasswordValid = true;

  final EditProfileController _changePasswordController =
      EditProfileController();

  @override
  void dispose() {
    _changePasswordController.dispose();
    super.dispose();
  }

  bool _hasUppercase(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  bool _hasNumber(String value) {
    return value.contains(RegExp(r'[0-9]'));
  }

  void _onPressedChangePasswordButton() async {
    // First check internet connection
    if (!await checkInternetOrShowDialog(
      context,
      title: "No Internet Connection",
      description: "Change password requires internet connection.",
    )) {
      return;
    }

    setState(() {
      oldPasswordValid = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        final isValid = await _changePasswordController.validateChangePassword(
          context,
        );

        if (isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Change password successfully!'),
              duration: Duration(seconds: 2),
              backgroundColor: Color.fromARGB(255, 54, 143, 57),
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          debugPrint('==== OLD PASSWORD INVALID ========');
          setState(() {
            oldPasswordValid = false;
          });
          _formKey.currentState!.validate();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        text: "Change Password",
        navigatePage: EditProfilePage(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                    "assets/icons/change_password_icon.png",
                  ),
                ),
                Text(
                  "Change Password",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Update your account password",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                SizedBox(height: 36),

                // Fomr
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomChangePasswordFormField(
                        controller:
                            _changePasswordController.oldPasswordController,
                        text: "OLD PASSWORD:",
                        // icon: Icons.lock,
                        hintText: "Old Password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Old Password is required!';
                          } else if (!oldPasswordValid) {
                            return 'Wrong Old Password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      CustomChangePasswordFormField(
                        controller:
                            _changePasswordController.newPasswordController,
                        text: "NEW PASSWORD:",
                        hintText: "New Password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'New Password is required!';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long!';
                          }
                          if (!_hasUppercase(value)) {
                            return 'Password must contain at least 1 uppercase letter!';
                          }
                          if (!_hasNumber(value)) {
                            return 'Password must contain at least 1 number!';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 12),
                      CustomChangePasswordFormField(
                        controller: _changePasswordController
                            .confirmNewPasswordController,
                        text: "CONFIRM NEW PASSWORD:",
                        hintText: "Confirm New Password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm new password!';
                          }
                          if (value !=
                              _changePasswordController
                                  .newPasswordController
                                  .text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        },
                      ),
                      // Password requirements
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password must be at least:",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "• 8 characters long",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "• 1 uppercase letter",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "• 1 number",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                CustomEditProfileButton(
                  onPressed: _onPressedChangePasswordButton,
                  text: "CHANGE PASSWORD",
                  description: "Set your new password",
                  textButton: "Change Password",
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChangePasswordModalSheetButton extends StatelessWidget {
  const ChangePasswordModalSheetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      height: 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Confirm New Password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text("Placeholder", style: TextStyle(fontSize: 14)),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Change Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
