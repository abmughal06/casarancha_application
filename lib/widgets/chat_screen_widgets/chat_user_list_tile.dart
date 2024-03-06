import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/ghost_message_details.dart';
import '../../models/message_details.dart';
import '../../models/user_model.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../common_widgets.dart';
import '../profile_pic.dart';
import '../text_widget.dart';

class ChatUserListTile extends StatelessWidget {
  const ChatUserListTile(
      {super.key,
      required this.message,
      required this.ontapTile,
      required this.personId});
  final MessageDetails message;
  final String personId;

  final VoidCallback ontapTile;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: DataProvider().getSingleUser(personId),
        initialData: null,
        catchError: (context, error) => null,
        child: Consumer<UserModel?>(builder: (context, personDetail, b) {
          if (personDetail == null) {
            return Container();
          }
          return StreamProvider.value(
            value: DataProvider().unSeenMessagesLength(message.id),
            initialData: null,
            catchError: (context, error) => null,
            child: Consumer<int?>(builder: (context, length, b) {
              // print(length);
              return length == null
                  ? Container()
                  : ListTile(
                      onTap: ontapTile,
                      title: Row(
                        children: [
                          TextWidget(
                            onTap: ontapTile,
                            text: personDetail.name,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff222939),
                          ),
                          widthBox(5.w),
                          verifyBadge(personDetail.isVerified)
                        ],
                      ),
                      subtitle: StreamProvider.value(
                        value: DataProvider().messages(message.id, false),
                        initialData: null,
                        catchError: (c, b) => null,
                        child: Consumer<List<Message>?>(
                            builder: (context, msg, b) {
                          return msg == null
                              ? widthBox(0)
                              : TextWidget(
                                  onTap: ontapTile,
                                  text: msg.first.type == 'Text'
                                      ? msg.first.content
                                      : ChatProvider()
                                          .getMediaType(msg.first.type),
                                  textOverflow: TextOverflow.ellipsis,
                                  fontWeight: length > 0
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: length > 0
                                      ? const Color(0xff000000)
                                      : const Color(0xff8a8a8a),
                                );
                        }),
                      ),
                      leading: ProfilePic(
                        pic: personDetail.imageStr,
                        heightAndWidth: 45.h,
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            onTap: ontapTile,
                            text: convertDateIntoTime(message.createdAt),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: const Color(0xff878787),
                          ),
                          SizedBox(height: 5.h),
                          length == 0
                              ? const Icon(Icons.navigate_next)
                              : Container(
                                  height: 19.h,
                                  width: 19.w,
                                  decoration: const BoxDecoration(
                                      color: Color(0xff7BC246),
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: TextWidget(
                                      text: length.toString(),
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      onTap: ontapTile,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    );
            }),
          );
        }));
  }
}

class GhostChatListTile extends StatelessWidget {
  const GhostChatListTile(
      {super.key, required this.messageDetails, required this.ontapTile});
  final GhostMessageDetails messageDetails;

  final VoidCallback ontapTile;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: DataProvider().getSingleUser(
          messageDetails.id.split('_').last == currentUserUID
              ? messageDetails.id.split('_').first
              : messageDetails.id.split('_').last),
      initialData: null,
      catchError: (context, error) => null,
      child: Consumer<UserModel?>(
        builder: (context, user, b) {
          if (user == null) {
            return widthBox(0);
          }
          return StreamProvider.value(
            value: DataProvider().unSeenMessagesLengthGhost(
                getConversationDocId(currentUserUID!, user.id)),
            initialData: null,
            catchError: (context, error) => null,
            child: Consumer<int?>(
              builder: (context, length, b) {
                return length == null
                    ? widthBox(0)
                    : SizedBox(
                        child: ListTile(
                          onTap: ontapTile,
                          title: Row(
                            children: [
                              TextWidget(
                                onTap: ontapTile,
                                text: user.name,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff222939),
                              ),
                              widthBox(5.w),
                              verifyBadge(
                                user.isVerified,
                              )
                            ],
                          ),
                          subtitle: StreamProvider.value(
                            value: DataProvider()
                                .messages(messageDetails.id, true),
                            initialData: null,
                            catchError: (c, b) => null,
                            child: Consumer<List<Message>?>(
                                builder: (context, msg, b) {
                              return msg == null
                                  ? widthBox(0)
                                  : TextWidget(
                                      onTap: ontapTile,
                                      text: msg.first.type == 'Text'
                                          ? msg.first.content
                                          : msg.first.type,
                                      textOverflow: TextOverflow.ellipsis,
                                      fontWeight: length > 0
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: length > 0
                                          ? const Color(0xff000000)
                                          : const Color(0xff8a8a8a),
                                    );
                            }),
                          ),
                          leading: ProfilePic(
                            pic: user.imageStr,
                            heightAndWidth: 45.h,
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextWidget(
                                onTap: ontapTile,
                                text: convertDateIntoTime(
                                    messageDetails.createdAt),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: const Color(0xff878787),
                              ),
                              SizedBox(height: 5.h),
                              !(length > 0)
                                  ? const Icon(Icons.navigate_next)
                                  : Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                          color: Color(0xff7BC246),
                                          shape: BoxShape.circle),
                                      child: TextWidget(
                                        text: messageDetails.unreadMessageCount
                                            .toString(),
                                        onTap: ontapTile,
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          );
        },
      ),
    );
  }
}

class GhostChatUserListTile extends StatelessWidget {
  const GhostChatUserListTile(
      {super.key, required this.messageDetails, required this.ontapTile});
  final GhostMessageDetails messageDetails;

  final VoidCallback ontapTile;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: DataProvider().getSingleUser(messageDetails.id),
      initialData: null,
      catchError: (context, error) => null,
      child: Consumer<UserModel?>(builder: (context, user, b) {
        if (user == null) {
          return Container();
        }
        return ListTile(
          onTap: ontapTile,
          title: Row(
            children: [
              TextWidget(
                onTap: ontapTile,
                text: user.ghostName,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff222939),
              ),
            ],
          ),
          subtitle: TextWidget(
            onTap: ontapTile,
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
            radius: 22.sp,
            backgroundColor: colorF03,
            child: Image.asset(
              imgGhostUser,
            ),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                onTap: ontapTile,
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
                      child: TextWidget(
                        onTap: ontapTile,
                        text: messageDetails.unreadMessageCount.toString(),
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }
}

class ChatUserListTileForNoChat extends StatelessWidget {
  const ChatUserListTileForNoChat(
      {super.key, required this.userModel, required this.ontapTile});
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
            verifyBadge(
              userModel.isVerified,
            )
          ],
        ),
        subtitle: TextWidget(
          text: appText(context).strStartChat(userModel.username),
          textOverflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: const Color(0xff8a8a8a),
        ),
        leading: ProfilePic(
          pic: userModel.imageStr,
          heightAndWidth: 45.h,
        ),
        trailing: const Icon(Icons.navigate_next),
      ),
    );
  }
}
