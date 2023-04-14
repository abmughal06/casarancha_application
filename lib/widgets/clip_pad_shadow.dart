import 'package:flutter/material.dart';

class ClipPad extends CustomClipper<Rect> {
  final EdgeInsets padding;

  const ClipPad({
    this.padding = EdgeInsets.zero
  });

  @override
  Rect getClip(Size size) => padding.inflateRect(Offset.zero & size);

  @override
  bool shouldReclip(ClipPad oldClipper) => oldClipper.padding != padding;
}