import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/screens/dashboard/provider/download_provider.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/music_player_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/media_details.dart';
import '../../models/message.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../text_widget.dart';

class ChatVideoTile extends StatefulWidget {
  const ChatVideoTile({
    super.key,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
    required this.media,
    this.mediaLength,
    this.caption,
  });

  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;
  final MediaDetails? media;
  final String? caption;
  final int? mediaLength;

  @override
  State<ChatVideoTile> createState() => _ChatVideoTileState();
}

class _ChatVideoTileState extends State<ChatVideoTile> {
  late VideoPlayerController videoPlayerController;
  // Future<String?> initThumbnail() async {
  //   return await VideoThumbnail.thumbnailFile(
  //     video: widget.link!,
  //     thumbnailPath: (await getTemporaryDirectory()).path,
  //     imageFormat: ImageFormat.PNG,
  //     maxHeight: 1024,
  //     maxWidth: 1024,
  //     quality: 10,
  //     // timeMs: (_controller.value.duration.inMilliseconds / 2).toInt(),
  //   );
  // }

  // String? image;

  // initImage() async {
  //   image = await initThumbnail();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.media!.link))
          ..initialize().then((value) {
            if (mounted) {
              setState(() {});
            }
          });
    // initImage();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: widget.isMe ? MediaQuery.of(context).size.width * .5 : 0,
                right:
                    widget.isMe ? 0 : MediaQuery.of(context).size.width * .5),
            child: Align(
              alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isMe ? colorF03.withOpacity(0.6) : colorFF4,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 9 / 13,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            VideoPlayer(videoPlayerController),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.black.withOpacity(0.2),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 40,
                                  color: colorWhite,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 12,
                              top: 12,
                              child: widget.mediaLength != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 4.h),
                                      child: TextWidget(
                                        text: '1/${widget.mediaLength}',
                                        fontSize: 9.sp,
                                        color: colorWhite,
                                      ),
                                    )
                                  : widthBox(0),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (widget.caption != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextWidget(
                            text: widget.caption,
                            color: colorBlack,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
          widget.media == null
              ? Align(
                  alignment: widget.isMe
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  child: Icon(
                    Icons.update_outlined,
                    color: color55F,
                    size: 12.sp,
                  ),
                )
              : DateAndSeenTile(
                  isMe: widget.isMe, isSeen: widget.isSeen, date: widget.date),
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
    super.key,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
    required this.media,
    this.caption,
  });

  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;
  final MediaDetails? media;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: isMe ? MediaQuery.of(context).size.width * .4 : 0,
                right: isMe ? 0 : MediaQuery.of(context).size.width * .4),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: media == null
                  ? Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: colorPrimaryA05,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                              bottomLeft: Radius.circular(
                                isMe ? 16.r : 0,
                              ),
                              bottomRight: Radius.circular(
                                isMe ? 0 : 16.r,
                              ))),
                      child: Center(
                        child: SizedBox(
                          height: 35.h,
                          width: 35.h,
                          child: CircularProgressIndicator(
                            color: colorWhite,
                            strokeWidth: 1.w,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: isMe ? colorF03.withOpacity(0.6) : colorFF4,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          MusicPlayerTile(
                            musicDetails: media!,
                            ontap: () {},
                            border: 16,
                            isMe: isMe,
                          ),
                          if (caption != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextWidget(
                                  text: caption,
                                  color: colorBlack,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
            ),
          ),
          media == null
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

class ChatVoiceTile extends StatelessWidget {
  const ChatVoiceTile({
    super.key,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
    required this.media,
  });

  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;
  final MediaDetails? media;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: isMe ? MediaQuery.of(context).size.width * .4 : 0,
                right: isMe ? 0 : MediaQuery.of(context).size.width * .4),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: media == null
                  ? Container(
                      // height: 70,
                      decoration: BoxDecoration(
                          color: colorPrimaryA05,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                              bottomLeft: Radius.circular(
                                isMe ? 16.r : 0,
                              ),
                              bottomRight: Radius.circular(
                                isMe ? 0 : 16.r,
                              ))),
                      child: Center(
                        child: SizedBox(
                          height: 35.h,
                          width: 35.h,
                          child: CircularProgressIndicator(
                            color: colorWhite,
                            strokeWidth: 1.w,
                          ),
                        ),
                      ),
                    )
                  : MusicPlayerTile(
                      musicDetails: media!,
                      ontap: () {},
                      border: 16,
                      isMe: isMe),
            ),
          ),
          media == null
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

class ChatDocumentTile extends StatelessWidget {
  const ChatDocumentTile({
    super.key,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
    required this.media,
    this.caption,
  });

  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;
  final MediaDetails? media;

  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadProvider>(builder: (c, downloadProgress, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: isMe ? MediaQuery.of(context).size.width * .5 : 0,
                right: isMe ? 0 : MediaQuery.of(context).size.width * .5,
              ),
              child: Align(
                alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                child: media == null
                    ? Container(
                        // height: 70,
                        decoration: BoxDecoration(
                            color: colorPrimaryA05,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.r),
                                topRight: Radius.circular(16.r),
                                bottomLeft: Radius.circular(
                                  isMe ? 16.r : 0,
                                ),
                                bottomRight: Radius.circular(
                                  isMe ? 0 : 16.r,
                                ))),
                        child: Center(
                          child: SizedBox(
                            height: 35.h,
                            width: 35.h,
                            child: CircularProgressIndicator(
                              color: colorWhite,
                              strokeWidth: 1.w,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: isMe ? colorF03.withOpacity(0.6) : colorFF4,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                downloadProgress.openDocument(
                                  media!.link,
                                  media!.name,
                                );
                              },
                              child: Container(
                                // height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.r),
                                    topRight: Radius.circular(16.r),
                                    bottomLeft: Radius.circular(
                                      isMe ? 16.r : 0,
                                    ),
                                    bottomRight: Radius.circular(
                                      isMe ? 0 : 16.r,
                                    ),
                                  ),
                                  color: isMe ? colorPrimaryA05 : colorFF4,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 10),
                                child: Row(
                                  children: [
                                    downloadProgress.isDocOpening
                                        ? const CircularProgressIndicator
                                            .adaptive(
                                            backgroundColor: colorWhite,
                                          )
                                        : Icon(
                                            Icons.file_copy,
                                            color: isMe ? colorWhite : color221,
                                            size: 25.sp,
                                          ),
                                    widthBox(12.w),
                                    Expanded(
                                      child: TextWidget(
                                        color: isMe ? colorWhite : color221,
                                        text: media!.name.split('/').last,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (caption != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextWidget(
                                    text: caption,
                                    color: colorBlack,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
              ),
            ),
            media == null
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
    });
  }
}

class ChatPostTile extends StatelessWidget {
  const ChatPostTile({
    super.key,
    required this.message,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.imageUrl,
  });

  final Message message;
  final String imageUrl;
  final bool isMe;
  final bool isSeen;
  final String appUserId;

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
    super.key,
    required this.message,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
  });

  final Message message;
  final bool isMe;
  final bool isSeen;
  final String appUserId;

  @override
  Widget build(BuildContext context) {
    final media = message.content != 'upload'
        ? message.content.map((e) => MediaDetails.fromMap(e)).toList()
        : null;

    final isUploading = media == null && !isMe;
    return !isUploading
        ? Padding(
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
                        color: isMe ? colorF03.withOpacity(0.6) : colorFF4,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 9 / 13,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorBlack.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                image: media != null
                                    ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          media.first.link,
                                        ),
                                      )
                                    : null,
                              ),
                              child: media == null
                                  ? centerLoader()
                                  : media.length > 1
                                      ? Align(
                                          alignment: isMe
                                              ? Alignment.topRight
                                              : Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 4.h),
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
                          if (message.caption.isNotEmpty)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: TextWidget(
                                  text: message.caption,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                media == null
                    ? Align(
                        alignment:
                            isMe ? Alignment.bottomRight : Alignment.bottomLeft,
                        child: Icon(
                          Icons.update_outlined,
                          color: color55F,
                          size: 12.sp,
                        ),
                      )
                    : DateAndSeenTile(
                        isMe: isMe, isSeen: isSeen, date: message.createdAt),
                heightBox(8)
              ],
            ),
          )
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }
}

class ChatQouteTile extends StatelessWidget {
  const ChatQouteTile({
    super.key,
    required this.message,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
  });

  final Message message;
  final bool isMe;
  final bool isSeen;
  final String appUserId;

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
      {super.key,
      required this.isMe,
      required this.isSeen,
      required this.date});
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
