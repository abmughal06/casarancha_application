import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_resources.dart';
import '../resources/strings.dart';

class TextWidget extends StatelessWidget {
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

  const TextWidget(
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
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(
        text ?? "",
        textAlign: textAlign,
        maxLines: maxLines,
        softWrap: true,
        overflow: textOverflow,
        style: textStyle ??
            TextStyle(
              shadows: shadow,
              color: color,
              height: textHeight,
              fontSize: fontSize ?? 14.sp,
              letterSpacing: letterSpacing,
              decoration: decoration,
              fontFamily: fontFamily ?? strFontName,
              fontWeight: fontWeight,
            ),
      ),
    );
  }
}
