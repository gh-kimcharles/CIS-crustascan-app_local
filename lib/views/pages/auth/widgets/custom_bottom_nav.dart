import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final Widget navigatePage;
  final String textMessage;
  final String textAuth;
  const CustomBottomNav({
    super.key,
    required this.navigatePage,
    required this.textMessage,
    required this.textAuth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(textMessage, style: TextStyle(fontSize: 16, color: Colors.grey)),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => navigatePage),
            );
          },
          child: Text(
            textAuth,
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 114, 22, 26),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
