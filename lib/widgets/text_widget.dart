import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_resources.dart';
import '../resources/strings.dart';

class TextWidget extends StatefulWidget {
  final String? text;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final GestureTapCallback? onTap;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final double? textHeight;
  final TextStyle? textStyle;
  final TextDecoration? decoration;
  final List<Shadow>? shadow;

  TextWidget(
      {Key? key,
      this.text,
      this.color = colorBlack,
      this.fontSize,
      this.fontFamily = strFontName,
      this.letterSpacing,
      this.textAlign,
      this.onTap,
      this.fontWeight = FontWeight.w400,
      this.textOverflow,
      this.maxLines,
      this.textHeight,
      this.textStyle,
      this.decoration,
      this.shadow})
      : super(key: key);

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: Text(
        widget.text ?? "",
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        softWrap: true,
        overflow: widget.textOverflow,
        style: widget.textStyle ??
            TextStyle(
              shadows: widget.shadow,
              color: widget.color,
              height: widget.textHeight,
              fontSize: widget.fontSize ?? 14.sp,
              letterSpacing: widget.letterSpacing,
              decoration: widget.decoration,
              fontFamily: widget.fontFamily ?? strFontName,
              fontWeight: widget.fontWeight,
            ),
      ),
    );
  }
}
