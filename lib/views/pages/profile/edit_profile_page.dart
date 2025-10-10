import 'package:crustascan_app/controllers/edit_profile_controller.dart';
import 'package:crustascan_app/views/pages/profile/change_password_page.dart';
import 'package:crustascan_app/views/pages/profile/profile_page.dart';
import 'package:crustascan_app/views/pages/profile/widgets/custom_edit_image_modal_bottom_sheet.dart';
import 'package:crustascan_app/views/pages/profile/widgets/profile_section_container.dart';
import 'package:crustascan_app/views/pages/profile/widgets/edit_profile_field_button.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crustascan_app/providers/user_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final EditProfileController _editProfileController = EditProfileController();

  @override
  void dispose() {
    _editProfileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        text: "Profile Information",
        navigatePage: ProfilePage(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            children: [
              SizedBox(height: 12),
              CustomEditImageModalBottomSheet(),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 38),
                    EditProfileFieldButton(
                      label: "First Name",
                      hintText: user.firstName,
                      controller: _editProfileController.newFirstNameController,
                      fieldName: "First Name",
                      editProfileController: _editProfileController,
                    ),
                    EditProfileFieldButton(
                      label: "Last Name",
                      hintText: user.lastName,
                      controller: _editProfileController.newLastNameController,
                      fieldName: "Last Name",
                      editProfileController: _editProfileController,
                    ),

                    // EditProfileFieldButton(
                    //   label: "Email",
                    //   hintText: user.email,
                    //   controller: _editProfileController.newEmailController,
                    //   fieldName: "Email",
                    //   editProfileController: _editProfileController,
                    // ),
                    EditProfileFieldButton(
                      label: "Username",
                      hintText: user.username,
                      controller: _editProfileController.newUsernameController,
                      fieldName: "Username",
                      editProfileController: _editProfileController,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              ProfileSectionContainer(
                icon: Icons.lock_reset,
                title: 'Change Password',
                navigatePage: ChangePasswordPage(),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
