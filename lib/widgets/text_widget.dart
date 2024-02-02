import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_resources.dart';
import '../resources/strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations appText(context) {
  return AppLocalizations.of(context)!;
}

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
      {super.key,
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
      this.shadow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(
        text ?? '',
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: textOverflow,

        // softWrap: true,
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

class SelectableTextWidget extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final double? textHeight;
  final TextStyle? textStyle;
  final TextDecoration? decoration;
  final List<Shadow>? shadow;
  const SelectableTextWidget(
      {super.key,
      this.text,
      this.color,
      this.fontSize,
      this.letterSpacing,
      this.textAlign,
      this.fontWeight,
      this.fontFamily,
      this.textOverflow,
      this.maxLines,
      this.textHeight,
      this.textStyle,
      this.decoration,
      this.shadow});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text ?? "",
      textAlign: textAlign,
      maxLines: maxLines,
      style: textStyle ??
          TextStyle(
            overflow: textOverflow,
            shadows: shadow,
            color: color,
            height: textHeight,
            fontSize: fontSize ?? 14.sp,
            letterSpacing: letterSpacing,
            decoration: decoration,
            fontFamily: fontFamily ?? strFontName,
            fontWeight: fontWeight,
          ),
    );
  }
}
