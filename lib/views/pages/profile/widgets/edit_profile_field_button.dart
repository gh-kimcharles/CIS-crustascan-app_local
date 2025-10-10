import 'package:crustascan_app/utils/helpers/connectivity_helper.dart';
import 'package:crustascan_app/views/pages/profile/widgets/edit_profile_text_form_field.dart';
import 'package:crustascan_app/controllers/edit_profile_controller.dart';
import 'package:flutter/material.dart';

class EditProfileFieldButton extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String fieldName;
  final EditProfileController editProfileController;

  const EditProfileFieldButton({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.fieldName,
    required this.editProfileController,
  });

  void showEditFieldModal({
    required BuildContext context,
    required String label,
    required String hintText,
    required TextEditingController controller,
    required String fieldName,
  }) {
    final _formKey = GlobalKey<FormState>();

    void onPressedSaveChangesButton() async {
      // First check internet connection
      if (!await checkInternetOrShowDialog(
        context,
        title: "No Internet Connection",
        description: "Edit account information requires internet connection.",
      )) {
        return;
      }

      if (_formKey.currentState!.validate()) {
        final isValid = editProfileController.validateSaveChanges(context);

        if (isValid) {
          try {
            await editProfileController.applyChanges(context);

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                duration: Duration(seconds: 2),
                backgroundColor: Color.fromARGB(255, 54, 143, 57),
              ),
            );

            Navigator.pop(context);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update profile: ${e.toString()}'),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid profile details. Try again!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 60,
            right: 60,
            top: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit $label",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EditProfileTextFormField(
                      controller: controller,
                      textInput: "$label:",
                      hintText: hintText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '$fieldName is required!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onPressedSaveChangesButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            240,
                            240,
                            240,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showEditFieldModal(
          context: context,
          label: label,
          hintText: hintText,
          controller: controller,
          fieldName: fieldName,
        );
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 55,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(hintText, style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
