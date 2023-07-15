import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../clip_pad_shadow.dart';
import '../common_widgets.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField(
      {Key? key, required this.ontapSend, required this.chatController})
      : super(key: key);
  final VoidCallback ontapSend;
  final TextEditingController chatController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 40 : 10),
        child: ClipRect(
          clipper: const ClipPad(padding: EdgeInsets.only(top: 30)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(color: colorWhite, boxShadow: [
              BoxShadow(
                color: colorPrimaryA05.withOpacity(.36),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(4, 0),
              ),
            ]),
            child: TextField(
              minLines: 1,
              maxLines: 3,
              controller: chatController,
              style: TextStyle(
                color: color239,
                fontSize: 16.sp,
                fontFamily: strFontName,
                fontWeight: FontWeight.w600,
              ),
              maxLength: 1500,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: strSaySomething,
                hintStyle: TextStyle(
                  color: color55F,
                  fontSize: 14.sp,
                  fontFamily: strFontName,
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widthBox(12.w),
                        GestureDetector(
                          onTap: ontapSend,
                          child: Image.asset(
                            imgSendComment,
                            height: 38.h,
                            width: 38.w,
                          ),
                        ),
                      ],
                    )),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                focusColor: Colors.transparent,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    color: Colors.transparent,
                  ),
                ),
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              onEditingComplete: () => FocusScope.of(context).unfocus(),
            ),
          ),
        ),
      ),
    );
  }
}
