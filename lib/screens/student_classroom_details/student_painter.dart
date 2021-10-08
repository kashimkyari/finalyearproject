import 'package:flutter/material.dart';

class StudentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height;
    double sw = size.width;
    Paint paint = Paint();

    Path path = Path();

    path.moveTo(0, sh);
    path.lineTo(0, 0.9 * sh);
    path.quadraticBezierTo(0.5 * sw, 0, sw, 0.9 * sh);
    path.lineTo(sw, sh);
    path.close();

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
