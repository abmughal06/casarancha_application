import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/color_resources.dart';
import '../../resources/strings.dart';
import '../text_widget.dart';

class SetupProfileTextField extends StatelessWidget {
  const SetupProfileTextField(
      {Key? key,
      required this.controller,
      required this.onchange,
      required this.limitfield,
      required this.countText,
      required this.hintText,
      required this.maxlines,
      required this.sizeHeight,
      required this.inputHeight})
      : super(key: key);

  final TextEditingController controller;
  final Function(String) onchange;
  final int limitfield;
  final String countText;
  final String hintText;
  final int maxlines;
  final double sizeHeight;
  final double inputHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizeHeight,
      child: TextFormField(
        controller: controller,
        onChanged: onchange,
        style: TextStyle(
          color: color239,
          fontSize: 16.sp,
          fontFamily: strFontName,
          fontWeight: FontWeight.w600,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(limitfield),
        ],
        cursorColor: color239,
        decoration: InputDecoration(
          filled: true,
          fillColor: colorFF4,
          suffixIcon: Container(
            padding: const EdgeInsets.all(10),
            width: 75.w,
            alignment: Alignment.bottomRight,
            height: inputHeight,
            child: TextWidget(
              text: countText,
              fontSize: 14.sp,
              color: color080,
              fontWeight: FontWeight.w400,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF3B3B3B).withOpacity(0.5),
            fontSize: 16.sp,
            fontFamily: strFontName,
            fontWeight: FontWeight.w300,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide.none),
        ),
        maxLines: maxlines,
        onEditingComplete: () => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
