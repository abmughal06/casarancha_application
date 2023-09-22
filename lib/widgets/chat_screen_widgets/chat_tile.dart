import 'package:casarancha/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../text_widget.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    required this.message,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
  }) : super(key: key);

  final String message;
  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: isMe ? 70 : 0, right: isMe ? 0 : 70),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(
                        isMe ? 16.r : 0,
                      ),
                      bottomRight: Radius.circular(
                        isMe ? 0 : 16.r,
                      )),
                  color: (isMe ? colorF03.withOpacity(0.6) : colorFF4),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                child: AppConstant()
                    .emojiSize(message, isMe ? color13F : color55F),
              ),
            ),
          ),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isMe
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: isSeen
                            ? SvgPicture.asset(
                                icChatMsgSend,
                              )
                            : SvgPicture.asset(
                                icChatMsgSend,
                                color: Colors.black.withOpacity(0.5),
                              ),
                      )
                    : Container(),
                TextWidget(
                  text: convertDateIntoTime(date),
                  color: colorAA3,
                  fontSize: 11.sp,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}
