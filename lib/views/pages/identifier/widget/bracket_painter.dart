import 'package:flutter/material.dart';

class BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const length = 30.0;

    // Top-left
    canvas.drawLine(Offset(0, 0), Offset(length, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, length), paint);

    // Top-right
    canvas.drawLine(
      Offset(size.width - length, 0),
      Offset(size.width, 0),
      paint,
    );
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, length), paint);

    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - length),
      paint,
    );
    canvas.drawLine(Offset(0, size.height), Offset(length, size.height), paint);

    // Bottom-right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - length, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
