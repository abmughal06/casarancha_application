import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField(
      {Key? key, required this.ontapSend, required this.chatController})
      : super(key: key);
  final VoidCallback ontapSend;
  final TextEditingController chatController;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chat, b) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: colorFF3,
            borderRadius: BorderRadius.circular(30),
          ),
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
            onChanged: (v) {
              chat.notifyUI();
            },
            focusNode: chat.textFieldFocus,
            maxLength: 1500,
            decoration: InputDecoration(
              isDense: true,
              counterText: "",
              border: InputBorder.none,
              hintText: strSaySomething,
              hintStyle: TextStyle(
                color: color55F,
                fontSize: 14.sp,
                fontFamily: strFontName,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.zero,
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
        );
      },
    );
  }
}
