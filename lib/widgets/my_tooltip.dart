import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_resources.dart';

class MyTooltip extends StatelessWidget {
  final String message;
  final Color backGndColor = colorBlack.withOpacity(0.7);
  MyTooltip({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomPaint(
          size: const Size(15.0, 10),
          painter: TrianglePainter(color: backGndColor),
        ),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backGndColor,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: colorWhite,
                  fontWeight: FontWeight.w600),
            )),
      ],
    );
  }
}

class ToolTipCustomShape extends ShapeBorder {
  final bool usePadding;

  const ToolTipCustomShape({this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 20 : 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect =
        Rect.fromPoints(rect.topLeft, rect.bottomRight - const Offset(0, 20));
    return Path()
      ..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 3)))
      ..moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy)
      ..relativeLineTo(10, 10)
      ..relativeLineTo(10, -10)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

class TrianglePainter extends CustomPainter {
  bool isDownArrow = false;
  Color color = colorBlack.withOpacity(0.7);

  TrianglePainter({required Color color});

  /// Draws the triangle of specific [size] on [canvas]
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    paint.strokeWidth = 2.0;
    paint.color = color;
    paint.style = PaintingStyle.fill;

    if (isDownArrow) {
      path.moveTo(0.0, -1.0);
      path.lineTo(size.width, -1.0);
      path.lineTo(size.width / 2.0, size.height);
    } else {
      path.moveTo(size.width / 2.0, 0.0);
      path.lineTo(0.0, size.height + 1);
      path.lineTo(size.width, size.height + 1);
    }

    canvas.drawPath(path, paint);
  }

  /// Specifies to redraw for [customPainter]
  @override
  bool shouldRepaint(CustomPainter customPainter) {
    return true;
  }
}

// class TooltipShapeBorder extends ShapeBorder {
//   final double arrowWidth;
//   final double arrowHeight;
//   final double arrowArc;
//   final double radius;
//
//   TooltipShapeBorder({
//     this.radius = 16.0,
//     this.arrowWidth = 20.0,
//     this.arrowHeight = 10.0,
//     this.arrowArc = 0.0,
//   }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);
//
//   @override
//   // TODO: implement dimensions
//   EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);
//
//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
//     // TODO: implement getInnerPath
//     throw UnimplementedError();
//   }
//
//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     // TODO: implement getOuterPath
//     rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
//     double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
//     return Path()
//       ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
//       ..moveTo(rect.bottomCenter.dx + x / 2, rect.bottomCenter.dy)
//       ..relativeLineTo(-x / 2 * r, y * r)
//       ..relativeQuadraticBezierTo(-x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
//       ..relativeLineTo(-x / 2 * r, -y * r);
//   }
//
//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
//     // TODO: implement paint
//   }
//
//   @override
//   ShapeBorder scale(double t) => this;
//
// }
