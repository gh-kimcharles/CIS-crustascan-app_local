import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String textButton;
  final bool? isGuestButton;
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.textButton,
    this.isGuestButton,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: isGuestButton == true
              ? const Color.fromARGB(255, 32, 32, 32)
              : Colors.white,
          backgroundColor: isGuestButton == true
              ? const Color.fromARGB(255, 224, 224, 224)
              : const Color.fromARGB(255, 114, 22, 26),
        ),
        child: Text(textButton, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
