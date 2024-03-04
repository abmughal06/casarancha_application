import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
import '../../resources/strings.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,
    required this.ontapSend,
    required this.chatController,
  });
  final VoidCallback ontapSend;
  final TextEditingController chatController;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chat, b) {
        return FocusScope(
          onFocusChange: (value) {
            chat.notifyUI();
          },
          child: TextField(
            minLines: 1,
            maxLines: 3,
            focusNode: chat.textFieldFocus,
            controller: chatController,
            style: TextStyle(
              color: color239,
              fontSize: 16.sp,
              fontFamily: strFontName,
              fontWeight: FontWeight.w600,
            ),
            textCapitalization: TextCapitalization.sentences,
            maxLength: 2000,
            decoration: InputDecoration(
              isDense: true,
              counterText: "",
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.w,
                  color: color080,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              hintText: appText(context).strSaySomething,
              hintStyle: TextStyle(
                color: color55F,
                fontSize: 14.sp,
                fontFamily: strFontName,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.all(7),
              focusColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.w,
                  color: color080,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        );
      },
    );
  }
}
