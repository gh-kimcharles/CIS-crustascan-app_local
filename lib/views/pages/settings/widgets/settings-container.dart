import 'package:flutter/material.dart';

class SettingsContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget navigatePage;

  const SettingsContainer({
    required this.icon,
    required this.title,
    required this.navigatePage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navigatePage),
        );
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 55,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: Row(
          children: [
            Icon(icon, size: 22),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 22),
          ],
        ),
      ),
    );
  }
}
