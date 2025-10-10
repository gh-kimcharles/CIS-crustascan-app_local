import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Widget navigatePage;
  final bool popOnly;

  const GlobalAppBar({
    super.key,
    required this.text,
    required this.navigatePage,
    this.popOnly = false, // default is false
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () {
          if (popOnly) {
            Navigator.pop(context); // Go back
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => navigatePage),
            );
          }
        },
      ),
      centerTitle: true,
      title: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
