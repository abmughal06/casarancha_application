import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../models/media_details.dart';
import '../../models/message.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../common_widgets.dart';
import '../text_widget.dart';
import 'chat_post_tile.dart';

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
            padding: EdgeInsets.only(
                left: isMe ? MediaQuery.of(context).size.width * .5 : 0,
                right: isMe ? 0 : MediaQuery.of(context).size.width * .5),
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

class ChatStoryVideoTile extends StatelessWidget {
  const ChatStoryVideoTile({
    Key? key,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
    required this.link,
    this.mediaLength,
    required this.message,
  }) : super(key: key);

  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;
  final String? link;
  final String message;
  final int? mediaLength;

  Future<String?> initThumbnail() async {
    return await VideoThumbnail.thumbnailFile(
      video: link!,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 1024,
      maxWidth: 1024,
      quality: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: isMe ? MediaQuery.of(context).size.width * .5 : 0,
                right: isMe ? 0 : MediaQuery.of(context).size.width * .5),
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
                  children: [
                    AspectRatio(
                      aspectRatio: 9 / 13,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: link == null
                            ? Container(
                                decoration: BoxDecoration(
                                  color: colorBlack.withOpacity(0.1),
                                ),
                                child: centerLoader(),
                              )
                            : FutureBuilder<String?>(
                                future: initThumbnail(),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    );
                                  }
                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(
                                          File(snapshot.data!),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          color: Colors.black.withOpacity(0.2),
                                          child: const Icon(
                                            Icons.play_arrow_rounded,
                                            size: 40,
                                            color: colorWhite,
                                          ),
                                        ),
                                        Positioned(
                                          right: 12,
                                          top: 12,
                                          child: mediaLength != null
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 4.h),
                                                  child: TextWidget(
                                                    text: '1/$mediaLength',
                                                    fontSize: 9.sp,
                                                    color: colorWhite,
                                                  ),
                                                )
                                              : widthBox(0),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextWidget(
                          text: message,
                          color: isMe ? color13F : color55F,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          link == null
              ? Align(
                  alignment:
                      isMe ? Alignment.bottomRight : Alignment.bottomLeft,
                  child: Icon(
                    Icons.update_outlined,
                    color: color55F,
                    size: 12.sp,
                  ),
                )
              : DateAndSeenTile(isMe: isMe, isSeen: isSeen, date: date),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}
