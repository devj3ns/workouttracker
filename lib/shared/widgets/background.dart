import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white),
        CustomPaint(
          child: Container(),
          painter: CurvePainter(),
        ),
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path = Path();
    path.lineTo(0, size.height * 0.28);
    path.quadraticBezierTo(
        size.width * 0.28, size.height * 0.30, size.width, 0);
    path.close();

    paint.color = Color.fromRGBO(249, 111, 92, 1);
    canvas.drawPath(path, paint);
    //...
    path = Path();
    path.lineTo(0, size.height * 0.29);
    path.quadraticBezierTo(
        size.width * 0.29, size.height * 0.31, size.width, 0);
    path.close();

    paint.color = Color.fromRGBO(249, 169, 95, 0.5);
    canvas.drawPath(path, paint);

    //.........
    path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width * 1.5, size.height * 0.5, 0, size.height);
    path.close();

    paint.color = Color.fromRGBO(79, 172, 254, 1);
    canvas.drawPath(path, paint);
    //...
    path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width * 1.4, size.height * 0.5, 0, size.height);
    path.close();

    paint.color = Color.fromRGBO(9, 234, 254, 0.5);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
