import 'package:crustascan_app/views/pages/profile/widgets/edit_profile_modal_sheet_button.dart';
import 'package:flutter/material.dart';

class CustomEditProfileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String description;
  final String textButton;

  const CustomEditProfileButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.description,
    required this.textButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              builder: (BuildContext context) {
                return EditProfileModalSheetButton(
                  onPressed: onPressed,
                  text: text,
                  description: description,
                  textButton: textButton,
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 114, 22, 26),
          ),
          child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
