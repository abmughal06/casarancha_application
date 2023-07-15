import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/ghost_message_details.dart';
import '../../models/message_details.dart';
import '../../models/user_model.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class ChatUserListTile extends StatelessWidget {
  const ChatUserListTile(
      {Key? key, required this.messageDetails, required this.ontapTile})
      : super(key: key);
  final MessageDetails messageDetails;

  final VoidCallback ontapTile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListTile(
        onTap: ontapTile,
        title: Row(
          children: [
            TextWidget(
              text: messageDetails.creatorDetails.name,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff222939),
            ),
            widthBox(5.w),
            Visibility(
                visible: messageDetails.creatorDetails.isVerified,
                child: SvgPicture.asset(icVerifyBadge))
          ],
        ),
        subtitle: TextWidget(
          text: messageDetails.lastMessage,
          textOverflow: TextOverflow.ellipsis,
          fontWeight: messageDetails.unreadMessageCount == 0
              ? FontWeight.w400
              : FontWeight.w700,
          fontSize: 14.sp,
          color: messageDetails.unreadMessageCount == 0
              ? const Color(0xff8a8a8a)
              : const Color(0xff000000),
        ),
        leading: CircleAvatar(
          backgroundImage: messageDetails.creatorDetails.imageUrl.isEmpty
              ? null
              : CachedNetworkImageProvider(
                  messageDetails.creatorDetails.imageUrl,
                ),
          child: messageDetails.creatorDetails.imageUrl.isEmpty
              ? const Icon(
                  Icons.question_mark,
                )
              : null,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              text: convertDateIntoTime(messageDetails.createdAt),
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: const Color(0xff878787),
            ),
            SizedBox(height: 5.h),
            messageDetails.unreadMessageCount == 0
                ? const Icon(Icons.navigate_next)
                : Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: Color(0xff7BC246), shape: BoxShape.circle),
                    child: Text(
                      messageDetails.unreadMessageCount.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class GhostChatUserListTile extends StatelessWidget {
  const GhostChatUserListTile(
      {Key? key, required this.messageDetails, required this.ontapTile})
      : super(key: key);
  final GhostMessageDetails messageDetails;

  final VoidCallback ontapTile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListTile(
        onTap: ontapTile,
        title: Row(
          children: [
            TextWidget(
              text: messageDetails.creatorDetails.name,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff222939),
            ),
            widthBox(5.w),
            Visibility(
                visible: messageDetails.creatorDetails.isVerified,
                child: SvgPicture.asset(icVerifyBadge))
          ],
        ),
        subtitle: TextWidget(
          text: messageDetails.lastMessage,
          textOverflow: TextOverflow.ellipsis,
          fontWeight: messageDetails.unreadMessageCount == 0
              ? FontWeight.w400
              : FontWeight.w700,
          fontSize: 14.sp,
          color: messageDetails.unreadMessageCount == 0
              ? const Color(0xff8a8a8a)
              : const Color(0xff000000),
        ),
        leading: CircleAvatar(
          backgroundImage: messageDetails.creatorDetails.imageUrl.isEmpty
              ? null
              : CachedNetworkImageProvider(
                  messageDetails.creatorDetails.imageUrl,
                ),
          child: messageDetails.creatorDetails.imageUrl.isEmpty
              ? const Icon(
                  Icons.question_mark,
                )
              : null,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              text: convertDateIntoTime(messageDetails.createdAt),
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: const Color(0xff878787),
            ),
            SizedBox(height: 5.h),
            messageDetails.unreadMessageCount == 0
                ? const Icon(Icons.navigate_next)
                : Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: Color(0xff7BC246), shape: BoxShape.circle),
                    child: Text(
                      messageDetails.unreadMessageCount.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ChatUserListTileForNoChat extends StatelessWidget {
  const ChatUserListTileForNoChat(
      {Key? key, required this.userModel, required this.ontapTile})
      : super(key: key);
  final UserModel userModel;

  final VoidCallback ontapTile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListTile(
        onTap: ontapTile,
        title: Row(
          children: [
            TextWidget(
              text: userModel.name,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff222939),
            ),
            widthBox(5.w),
            Visibility(
                visible: userModel.isVerified,
                child: SvgPicture.asset(icVerifyBadge))
          ],
        ),
        subtitle: TextWidget(
          text: "Start chat with ${userModel.username}",
          textOverflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: const Color(0xff8a8a8a),
        ),
        leading: CircleAvatar(
          backgroundImage: userModel.imageStr.isEmpty
              ? null
              : CachedNetworkImageProvider(
                  userModel.imageStr,
                ),
          child: userModel.imageStr.isEmpty
              ? const Icon(
                  Icons.question_mark,
                )
              : null,
        ),
        trailing: const Icon(Icons.navigate_next),
      ),
    );
  }
}