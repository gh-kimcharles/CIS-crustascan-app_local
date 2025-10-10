import 'package:flutter/material.dart';

class GlobalLogoHeaderContainer extends StatelessWidget {
  final String text;
  final String description;

  const GlobalLogoHeaderContainer({
    super.key,
    required this.text,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/logos/cis_logo2.png", height: 80, width: 80),
        const SizedBox(height: 10),
        Text(
          text,
          style: TextStyle(
            color: Color.fromARGB(255, 114, 22, 26),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(description, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
