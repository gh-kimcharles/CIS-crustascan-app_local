import 'package:flutter/material.dart';

class PredictSectionContainer extends StatelessWidget {
  final String header;
  final String text;
  const PredictSectionContainer({
    super.key,
    required this.header,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            header,
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Divider(thickness: 2, color: Colors.grey, height: 12),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
