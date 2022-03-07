import 'package:flutter/material.dart';

class ShapePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 450
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 50);

    canvas.drawCircle(center, 135, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ShapePainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 500
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 50);

    canvas.drawCircle(center, 135, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Users {
  final String imagePath;
  final String name;
  final String email;
  final String accbalance;
  final String token;
  final bool isDarkMode;

  const Users({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.accbalance,
    required this.token,
    required this.isDarkMode,
  });
}
