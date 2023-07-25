import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/media_details.dart';
import '../../models/message.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../text_widget.dart';

class ChatStoryTile extends StatelessWidget {
  const ChatStoryTile({
    Key? key,
    required this.message,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
  }) : super(key: key);

  final Message message;
  final bool isMe;
  final bool isSeen;
  final String appUserId;

  @override
  Widget build(BuildContext context) {
    final story = MediaDetails.fromMap(message.content);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: isMe ? 170 : 0, right: isMe ? 0 : 170),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: colorF03.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
                    bottomLeft: Radius.circular(isMe ? 15 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AspectRatio(
                      aspectRatio: 9 / 13,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              story.link,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                      child: TextWidget(
                        text: message.caption,
                        color: isMe ? color13F : color55F,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
                        child: message.isSeen
                            ? SvgPicture.asset(icChatMsgSend)
                            : null,
                      )
                    : Container(),
                TextWidget(
                  text: convertDateIntoTime(message.createdAt),
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
