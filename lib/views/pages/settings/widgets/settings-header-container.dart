import 'package:flutter/material.dart';

class SettingsHeaderContainer extends StatelessWidget {
  final String text;
  final String description;
  const SettingsHeaderContainer({
    super.key,
    required this.text,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/logos/cis_logo2.png", height: 100, width: 100),
        const SizedBox(height: 10),
        Text(
          "CrustaScan",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 22, 26),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(description, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
