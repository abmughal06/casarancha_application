import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

import '../../models/media_details.dart';
import '../../models/message.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../music_player_url.dart';
import '../text_widget.dart';

class ChatVideoTile extends StatefulWidget {
  const ChatVideoTile({
    Key? key,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
    required this.videoPlayerController,
    required this.aspectRatio,
  }) : super(key: key);

  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;
  final VideoPlayerController videoPlayerController;
  final double aspectRatio;

  @override
  State<ChatVideoTile> createState() => _ChatVideoTileState();
}

class _ChatVideoTileState extends State<ChatVideoTile> {
  @override
  void initState() {
    super.initState();
    widget.videoPlayerController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: widget.isMe ? 70 : 0, right: widget.isMe ? 0 : 70),
            child: Align(
              alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
              child: AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                          bottomLeft: Radius.circular(
                            widget.isMe ? 16.r : 0,
                          ),
                          bottomRight: Radius.circular(
                            widget.isMe ? 0 : 16.r,
                          )),
                      color:
                          (widget.isMe ? colorF03.withOpacity(0.6) : colorFF4),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    child: VideoPlayer(widget.videoPlayerController)),
              ),
            ),
          ),
          Align(
            alignment:
                widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.isMe
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: widget.isSeen
                            ? SvgPicture.asset(icChatMsgSend)
                            : null,
                      )
                    : Container(),
                TextWidget(
                  text: convertDateIntoTime(widget.date),
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

class ChatMusicTile extends StatelessWidget {
  const ChatMusicTile({
    Key? key,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
    required this.media,
    required this.aspectRatio,
  }) : super(key: key);

  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;
  final MediaDetails media;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: isMe ? 70 : 0, right: isMe ? 0 : 70),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: AspectRatio(
                aspectRatio: aspectRatio,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    child: MusicPlayerUrl(
                      musicDetails: media,
                      ontap: () {},
                    )),
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
                        child: isSeen ? SvgPicture.asset(icChatMsgSend) : null,
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

class ChatPostTile extends StatelessWidget {
  const ChatPostTile({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                  child: message.type == "Photo"
                      ? CachedNetworkImage(
                          imageUrl: message.content['mediaData'][0]['link'],
                          // color: isMe ? color13F : color55F,
                          // fontWeight: FontWeight.w500,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 50,
                          ),
                          child: Center(
                            child: Text(
                              message.content['mediaData'][0]['link'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: color221,
                              ),
                            ),
                          ),
                        )),
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
