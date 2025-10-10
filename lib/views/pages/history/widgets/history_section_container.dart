import 'package:flutter/material.dart';

class HistorySectionContainer extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;

  const HistorySectionContainer({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      hoverColor: Colors.grey[200],
      child: Ink(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }
}
