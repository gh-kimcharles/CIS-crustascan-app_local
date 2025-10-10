import 'package:flutter/material.dart';

class HistoryDetailsSectionContainer extends StatelessWidget {
  final String header;
  final String text;
  const HistoryDetailsSectionContainer({
    super.key,
    required this.header,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize;
    if (text.length >= 20) {
      fontSize = 12; // very small text for long content
    } else if (text.length >= 15) {
      fontSize = 14;
    } else {
      fontSize = 16;
    }

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
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                top: fontSize == 16 || fontSize == 14 ? 8 : 0,
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
