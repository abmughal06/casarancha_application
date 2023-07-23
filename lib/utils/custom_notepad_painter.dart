// import 'package:flutter/material.dart';

// class CustomNotepadPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     // final paintgrey = Paint()..color = c;
//     // var rrectRed =
//     //     RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(0));
//     // canvas.drawRRect(rrectRed, paintgrey);

//     final paintDarkgrey = Paint()
//       ..color = Colors.blueGrey
//       ..strokeWidth = 1.0;
//     for (var i = 0.0; i <= size.height; i = i + 40) {
//       // double offSet = size.height * i * .06;
//       canvas.drawLine(Offset(0, i), Offset(size.width, i), paintDarkgrey);
//     }

//     final paintPink = Paint()
//       ..color = Colors.transparent
//       ..strokeWidth = 0;
//     canvas.drawLine(Offset(size.width * .1, 0),
//         Offset(size.width * .1, size.height), paintPink);
//   }

//   @override
//   bool shouldRepaint(CustomNotepadPainter oldDelegate) {
//     return false;
//   }

//   @override
//   bool shouldRebuildSemantics(CustomNotepadPainter oldDelegate) {
//     return false;
//   }
// }
