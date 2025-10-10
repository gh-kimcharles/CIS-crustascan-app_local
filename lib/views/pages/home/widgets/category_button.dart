import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final Function()? onPressed;
  final String iconPath;
  final String text;
  final bool focused;

  const CategoryButton({
    super.key,
    required this.onPressed,
    required this.iconPath,
    required this.text,
    required this.focused,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 4),
      child: SizedBox(
        width: 140,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 4,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: focused
                ? const Color.fromARGB(255, 114, 22, 26)
                : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: 28,
                height: 28,
                color: focused
                    ? Colors.white
                    : const Color.fromARGB(255, 114, 22, 26),
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: focused
                      ? Colors.white
                      : const Color.fromARGB(255, 114, 22, 26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
