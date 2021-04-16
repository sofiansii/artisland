import 'package:artisland/main.dart';
import 'package:flutter/material.dart';

class PenArt extends StatelessWidget {
  final Widget child;
  final double headStart;
  final double headEnd;
  PenArt({this.child, this.headStart = 0.7, this.headEnd = .9});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: MyPainter(this.headStart, this.headEnd), child: child);
  }
}

class MyPainter extends CustomPainter {
  final double headStart;
  final double headEnd;
  const MyPainter(this.headStart, this.headEnd);
  @override
  void paint(Canvas canvas, Size size) {
    Color primary = Colors.grey[200];
    Color shadow = Colors.grey[400];
    var paint = Paint()..strokeWidth = 1;
    paint.style = PaintingStyle.fill;
    double diffSize = 5;

    //shapes
    var mainRect = Rect.fromPoints(
        Offset(diffSize, 0), Offset(size.width, size.height * this.headStart));
    var secondaryRect = Rect.fromPoints(
        Offset(0, diffSize),
        Offset(mainRect.bottomRight.dx - diffSize,
            mainRect.bottomLeft.dy + diffSize));
    var head =
        Offset((size.width / 2) + diffSize / 2, size.height * this.headEnd);

    //paths
    var rect1 = Path()..addRect(mainRect);
    var rect2 = Path()
      ..addPolygon([
        Offset(0, diffSize),
        mainRect.topLeft,
        mainRect.bottomLeft,
        secondaryRect.bottomLeft
      ], true);
    var mainTriangle1 = Path()
      ..addPolygon([mainRect.bottomRight, mainRect.bottomLeft, head], true);
    var mainTriangle2 = Path()
      ..addPolygon([secondaryRect.bottomLeft, mainRect.bottomLeft, head], true);
    //head point path2
    var vec1 = head + (mainRect.bottomRight - head) * 0.3;
    var vec2 = head + (mainRect.bottomLeft - head) * 0.3;
    var vec3 = head + (secondaryRect.bottomLeft - head) * 0.3;
    var headTriangle = Path()
      ..moveTo(head.dx, head.dy)
      ..lineTo(vec1.dx, vec1.dy)
      ..lineTo(vec2.dx, vec1.dy)
      ..lineTo(head.dx, head.dy);
    var headTriangle2 = Path()
      ..moveTo(head.dx, head.dy)
      ..lineTo(vec2.dx, vec2.dy)
      ..lineTo(vec3.dx, vec3.dy)
      ..lineTo(head.dx, head.dy);

    //draw main rects and traingles
    paint.color = primary;
    canvas.drawPath(rect1, paint);
    paint.color = shadow;
    canvas.drawPath(rect2, paint);
    paint.color = primary;
    canvas.drawPath(mainTriangle1, paint);
    paint.color = shadow;
    canvas.drawPath(mainTriangle2, paint);

    //draw head triangles
    paint.color = Colors.black;
    canvas.drawPath(headTriangle, paint);
    canvas.drawPath(headTriangle2, paint);

    //draw stroke outline over all shapes
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.black;
    canvas.drawPath(rect1, paint);
    canvas.drawPath(rect2, paint);
    canvas.drawPath(mainTriangle1, paint);
    canvas.drawPath(mainTriangle2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
