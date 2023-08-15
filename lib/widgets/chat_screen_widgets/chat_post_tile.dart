import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../models/media_details.dart';
import '../../models/message.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../text_widget.dart';

class ChatVideoTile extends StatelessWidget {
  const ChatVideoTile({
    Key? key,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
    required this.link,
    this.mediaLength,
  }) : super(key: key);

  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;
  final String link;
  final int? mediaLength;

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
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
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
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 4.h),
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
            ),
          ),
          DateAndSeenTile(isMe: isMe, isSeen: isSeen, date: date),
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
              child: VoiceMessage(
                audioSrc: media.link,
                meBgColor: Colors.black,
                played: false, // To show played badge or not.
                me: true, // Set message side.
                onPlay: () {}, // Do something when voice played.
              ),
            ),
          ),
          DateAndSeenTile(isMe: isMe, isSeen: isSeen, date: date),
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
    required this.imageUrl,
  }) : super(key: key);

  final Message message;
  final String imageUrl;
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
                        imageUrl,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          DateAndSeenTile(isMe: isMe, isSeen: isSeen, date: message.createdAt),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}

class ChatImageTile extends StatelessWidget {
  const ChatImageTile({
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
    final media = message.content.map((e) => MediaDetails.fromMap(e)).toList();
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
                        media.first.link,
                      ),
                    ),
                  ),
                  child: media.length > 1
                      ? Align(
                          alignment:
                              isMe ? Alignment.topRight : Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 4.h),
                              child: TextWidget(
                                text: '1/${media.length}',
                                fontSize: 9.sp,
                                color: colorWhite,
                              ),
                            ),
                          ),
                        )
                      : widthBox(0),
                ),
              ),
            ),
          ),
          DateAndSeenTile(isMe: isMe, isSeen: isSeen, date: message.createdAt),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}

class ChatQouteTile extends StatelessWidget {
  const ChatQouteTile({
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
                aspectRatio: 1 / 1,
                child: Container(
                  padding: EdgeInsets.all(15.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: isMe ? colorF03.withOpacity(0.6) : colorFF3,
                  ),
                  child:
                      TextWidget(text: message.content['mediaData'][0]['link']),
                ),
              ),
            ),
          ),
          DateAndSeenTile(isMe: isMe, isSeen: isSeen, date: message.createdAt),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}

class DateAndSeenTile extends StatelessWidget {
  const DateAndSeenTile(
      {Key? key, required this.isMe, required this.isSeen, required this.date})
      : super(key: key);
  final bool isMe;
  final bool isSeen;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Align(
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
                      : null,
                )
              : Container(),
          TextWidget(
            text: convertDateIntoTime(date),
            color: colorAA3,
            fontSize: 11.sp,
          ),
        ],
      ),
    );
  }
}
