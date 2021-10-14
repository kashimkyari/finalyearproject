import 'package:flutter/material.dart';

class StudentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = 320;
    double sw = 100;
    Paint paint = Paint();

    Path path = Path();

    var rect = Offset.zero & size;
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color.fromRGBO(235, 66, 66, 1), Color.fromRGBO(183, 34, 34, 1)],
    ).createShader(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
