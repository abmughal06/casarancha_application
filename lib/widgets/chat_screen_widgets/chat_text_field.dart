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

  void _onTextChanged() {
    final text = chatController.text;
    if (text.isNotEmpty) {
      // Capitalize the first letter
      String newText = text.substring(0, 1).toUpperCase() + text.substring(1);

      // Capitalize letter after a period (.)
      for (int i = 1; i < text.length - 1; i++) {
        if (text[i - 1] == '.' && text[i] == ' ') {
          newText = newText.substring(0, i + 1) +
              text[i + 1].toUpperCase() +
              newText.substring(i + 2);
          i++; // Skip the next character since it has already been capitalized
        }
      }

      if (text != newText) {
        chatController.value = chatController.value.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chat, b) {
        return Focus(
          focusNode: chat.textFieldFocus,
          onFocusChange: (value) {
            chat.notifyUI();
          },
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
              _onTextChanged();
            },
            // focusNode: chat.textFieldFocus,
            maxLength: 1500,
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
            // onTap: () {
            //   chat.textFieldFocus.requestFocus();
            //   chat.notifyUI();
            // },
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            // onTapOutside: (v) {
            //   chat.textFieldFocus.unfocus();
            //   chat.notifyUI();
            // },
            // onSubmitted: (v) {
            //   chat.textFieldFocus.unfocus();
            //   chat.notifyUI();
            // },
          ),
        );
      },
    );
  }
}
