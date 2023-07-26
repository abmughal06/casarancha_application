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
import '../music_player_url.dart';
import '../text_widget.dart';

class ChatVideoTile extends StatelessWidget {
  const ChatVideoTile({
    Key? key,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
    required this.link,
  }) : super(key: key);

  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;
  final String link;

  Future<String?> initThumbnail() async {
    return await VideoThumbnail.thumbnailFile(
      video: link,
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: isMe ? 170 : 0, right: isMe ? 0 : 170),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: AspectRatio(
                aspectRatio: 9 / 13,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FutureBuilder<String?>(
                    future: initThumbnail(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const CircularProgressIndicator.adaptive();
                      } else {
                        return Image.file(
                          File(snapshot.data!),
                          fit: BoxFit.fill,
                        );
                      }
                    },
                  ),
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

class ChatMusicTile extends StatelessWidget {
  const ChatMusicTile({
    Key? key,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
    required this.media,
  }) : super(key: key);

  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;
  final MediaDetails media;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: isMe ? 100 : 0, right: isMe ? 0 : 100),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: Column(
                children: [
                  MusicPlayerTile(
                    border: 15,
                    musicDetails: media,
                    ontap: () {},
                  ),
                ],
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
            padding:
                EdgeInsets.only(left: isMe ? 170 : 0, right: isMe ? 0 : 170),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: AspectRatio(
                aspectRatio: 9 / 13,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        message.content['mediaData'][0]['link'],
                      ),
                    ),
                  ),
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
