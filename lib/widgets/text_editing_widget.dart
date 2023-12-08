import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_resources.dart';
import '../resources/strings.dart';
import 'asset_image_widget.dart';

class TextEditingWidget extends StatelessWidget {
  final String? hint;
  final String? suffixText;
  final Widget? prefixIcon;
  final Widget? suffixWidget;
  final Color? color;
  final Color? hintColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final bool? readOnly;
  final TextAlign? textAlign;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final int? maxLines;
  final bool? isDense;
  final GestureTapCallback? onTap;
  final Function? onTapSuffixIcon;
  final double? height;
  final double? textHeight;
  final double? width;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool isShadowEnable;
  final bool isBorderEnable;
  final String? fontFamilyText;
  final String? suffixFontFamilyText;
  final String? fontFamilyHint;
  final FontWeight? fontWeightText;
  final FontWeight? suffixFontWeightText;
  final FontWeight? fontWeightHint;
  final String? suffixIconName;
  final Widget? suffixIconWidget;
  final double? suffixIconHeight;
  final double? suffixIconWidth;
  final bool passwordVisible;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool autoFocus;
  final bool expands;
  final double? fontSize;
  final double? suffixFontSize;
  final String? counterText;
  final Color? fieldBorderClr;
  final double? borderRadius;
  final double? contentPadding;

  const TextEditingWidget(
      {super.key,
      this.hint,
      this.suffixText,
      this.suffixWidget,
      this.expands = false,
      this.autoFocus = false,
      this.prefixIcon,
      this.color,
      this.controller,
      this.focusNode,
      this.initialValue,
      this.readOnly,
      this.textAlign,
      this.suffixIcon,
      this.textInputType,
      this.maxLines = 1,
      this.isDense,
      this.onTap,
      this.height,
      this.onFieldSubmitted,
      this.validator,
      this.maxLength,
      this.textInputAction,
      this.inputFormatters,
      this.width,
      this.hintColor,
      this.isBorderEnable = true,
      this.isShadowEnable = false,
      this.fontFamilyText,
      this.suffixFontFamilyText,
      this.suffixFontWeightText,
      this.fontFamilyHint,
      this.fontWeightHint,
      this.fontWeightText,
      this.suffixIconName,
      this.suffixIconHeight,
      this.suffixIconWidth,
      this.onTapSuffixIcon,
      this.passwordVisible = false,
      this.suffixIconWidget,
      this.onChanged,
      this.onEditingComplete,
      this.counterText,
      this.fontSize,
      this.suffixFontSize,
      this.fieldBorderClr,
      this.borderRadius,
      this.textHeight,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        autofocus: autoFocus,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        validator: validator,
        onTap: onTap,
        obscureText: passwordVisible,
        maxLength: maxLength,
        controller: controller,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        initialValue: initialValue,
        readOnly: readOnly ?? false,
        maxLines: maxLines,
        textAlign: textAlign ?? TextAlign.left,
        keyboardType: textInputType,
        expands: expands,
        style: TextStyle(
            color: color239,
            fontSize: fontSize ?? 16.sp,
            fontFamily: fontFamilyText ?? strFontName,
            fontWeight: fontWeightText ?? FontWeight.w600,
            height: textHeight),
        cursorColor: color239,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onTapOutside: (v) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          enabled: true,
          counterText: counterText ?? "",
          isDense: isDense,
          prefixIcon: prefixIcon,
          focusColor: Colors.black12,
          suffixText: suffixText,
          suffix: suffixWidget,
          suffixStyle: TextStyle(
            color: color080,
            fontSize: suffixFontSize ?? 14.sp,
            fontFamily: suffixFontFamilyText ?? strFontName,
            fontWeight: suffixFontWeightText ?? FontWeight.w400,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: fieldBorderClr ?? Colors.transparent, width: 2.0),
            borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
          ),
          suffixIcon: suffixIconWidget ??
              (suffixIconName != null
                  ? InkWell(
                      onTap: () {
                        bool data = !passwordVisible;
                        onTapSuffixIcon!(data);
                      },
                      child: AssetImageWidget(
                        // imageName: passwordVisible ? icEye : suffixIconName!,
                        width: suffixIconWidth,
                        height: suffixIconHeight,
                      ),
                    )
                  : null),
          hintText: hint,
          errorMaxLines: 2,
          contentPadding: EdgeInsets.symmetric(
              horizontal: contentPadding ?? 12.w,
              vertical: contentPadding ?? 12.h),
          hintStyle: TextStyle(
            color: hintColor ?? const Color(0xFF3B3B3B).withOpacity(0.5),
            fontSize: 14.sp,
            fontFamily: fontFamilyHint ?? strFontName,
            fontWeight: fontWeightHint ?? FontWeight.w300,
          ),
          filled: true,
          fillColor: color ?? Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
