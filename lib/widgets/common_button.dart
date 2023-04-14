import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/color_resources.dart';
import '../resources/strings.dart';
import 'text_widget.dart';

class CommonButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String? text;
  final String? stringAssetName;
  final GestureTapCallback? onTap;
  final double? verticalOutMargin;
  final double? horizontalOutMargin;
  final bool showLoading;
  final bool isShadowEnable;
  final bool isIcon;
  final bool isTrailingIcon;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? assetHeight;
  final double? assetWidth;
  final double? fontSize;
  final double borderWidth;
  final Widget? iconWidget;
  final FontWeight? txtFontWeight;

  const CommonButton(
      {Key? key,
      this.width,
      this.height,
      this.text,
      this.onTap,
      this.showLoading = false,
      this.textColor,
      this.verticalPadding,
      this.stringAssetName,
      this.isIcon = false,
      this.verticalOutMargin,
      this.horizontalOutMargin,
      this.assetWidth,
      this.assetHeight,
      this.fontSize,
      this.horizontalPadding,
      this.borderColor,
      this.backgroundColor,
      this.borderWidth = 1.0,
      this.iconWidget,
      this.txtFontWeight,
      this.isShadowEnable = true,
      this.isTrailingIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(
          horizontal: horizontalOutMargin ?? 0,
          vertical: verticalOutMargin ?? 0,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? colorPrimaryA05,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: isShadowEnable
              ? [
                  BoxShadow(
                    color: colorPrimaryA05.withOpacity(.36),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.grey.shade300,
                    // offset: const Offset(-5,0),
                  ),
                  BoxShadow(
                    color: Colors.grey.shade300,
                    // offset: const Offset(5,0),
                  )
                ]
              : [
                  const BoxShadow(
                    color: Colors.transparent,
                    // offset: const Offset(5,0),
                  )
                ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding ?? 15,
              horizontal: horizontalPadding ?? 0.0),
          child: Center(
            child: showLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: colorWhite,
                      strokeWidth: 3,
                    ),
                  )
                : isIcon
                    ? Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 34.0, right: 30),
                            child: SvgPicture.asset(
                              stringAssetName!,
                              height: assetHeight,
                              width: assetWidth,
                            ),
                          ),
                          TextWidget(
                            text: text,
                            fontSize: fontSize ?? 14.sp,
                            fontWeight: txtFontWeight ?? FontWeight.w600,
                            fontFamily: strFontName,
                            color: textColor ?? colorWhite,
                          ),
                        ],
                      )
                    : isTrailingIcon
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Spacer(),
                              TextWidget(
                                text: "text",
                                fontSize: fontSize ?? 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: strFontName,
                                color: Colors.transparent,
                              ),
                              TextWidget(
                                text: text,
                                fontSize: fontSize ?? 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: strFontName,
                                color: textColor ?? colorWhite,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15.w),
                                child: iconWidget!,
                              ),
                            ],
                          )
                        : TextWidget(
                            text: text,
                            fontSize: fontSize ?? 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: strFontName,
                            color: textColor ?? colorWhite,
                          ),
          ),
        ),
      ),
    );
  }
}
