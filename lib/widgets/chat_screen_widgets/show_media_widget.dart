import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:provider/provider.dart';

class ShowMediaToSendInChat extends StatelessWidget {
  const ShowMediaToSendInChat(
      {super.key,
      required this.currentUser,
      required this.appUser,
      this.firstMessage,
      this.isGhost = false});
  final UserModel currentUser;
  final UserModel appUser;
  final bool? firstMessage;
  final bool isGhost;

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: colorBlack,
      appBar: AppBar(
        backgroundColor: colorBlack,
        title: TextWidget(
          text: 'Send Media',
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: colorWhite,
        ),
        leadingWidth: 50,
        leading: GestureDetector(
          onTap: () {
            media.clearLists();
          },
          child: const Icon(
            Icons.navigate_before,
            size: 40,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => media.photosList.isNotEmpty
                ? media.getPhoto(context)
                : media.mediaList.isNotEmpty
                    ? media.getMedia(context)
                    : media.getVideo(context),
            child: Image.asset(
              imgAddPost,
              height: 38.h,
              width: 38.w,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          heightBox(15.h),
          SizedBox(
            height: MediaQuery.of(context).size.height * .70,
            child: Center(
              child: AspectRatio(
                aspectRatio: 9 / 13,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: media.photosList.isNotEmpty
                      ? media.photosList.length
                      : media.videosList.isNotEmpty
                          ? media.videosList.length
                          : media.mediaList.isNotEmpty
                              ? media.mediaList.length
                              : media.musicList.length,
                  itemBuilder: (context, index) {
                    if (media.videosList.isNotEmpty) {
                      return AspectRatio(
                        aspectRatio: 9 / 13,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: NativeVideoView(
                                useExoPlayer: false,
                                keepAspectRatio: false,
                                showMediaController: true,
                                onCreated: (VideoViewController controller) {
                                  controller.setVideoSource(
                                      media.videosList[index].path,
                                      sourceType: VideoSourceType.file);
                                },
                                onPrepared: (VideoViewController controller,
                                    VideoInfo videoInfo) {
                                  controller
                                      .play()
                                      .then((value) =>
                                          const Duration(milliseconds: 1000))
                                      .then((value) => controller.pause());
                                },
                                onCompletion:
                                    (VideoViewController controller) {},
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  media
                                      .removeVideoFile(media.videosList[index]);
                                },
                                child: SvgPicture.asset(icRemovePost),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    if (media.musicList.isNotEmpty) {
                      return AspectRatio(
                        aspectRatio: 13 / 9,
                        child: Stack(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MusicPlayerWithFile(
                                    musicFile: media.musicList[index])),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  media.removeMusicFile(media.musicList[index]);
                                },
                                child: SvgPicture.asset(icRemovePost),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    if (media.photosList.isNotEmpty) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              media.photosList[index],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: InkWell(
                              onTap: () {
                                media.removePhotoFile(media.photosList[index]);
                              },
                              child: SvgPicture.asset(icRemovePost),
                            ),
                          )
                        ],
                      );
                    }
                    if (media.mediaList.isNotEmpty) {
                      return Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.width * .6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: colorPrimaryA05,
                            ),
                            child: Center(
                                child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.file_copy,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: TextWidget(
                                    color: Colors.white,
                                    text: media.mediaList[index].path
                                        .split('/')
                                        .last,
                                  ),
                                )
                              ],
                            )),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: InkWell(
                              onTap: () {
                                media.removeMediaFile(media.mediaList[index]);
                              },
                              child: SvgPicture.asset(icRemovePost),
                            ),
                          )
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: appText(context).strWriteCommentHere,
                hintStyle: TextStyle(
                  color: colorWhite,
                  fontSize: 14.sp,
                  fontFamily: strFontName,
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: svgImgButton(
                    svgIcon: icStoryCmtSend,
                    onTap: () {
                      if (isGhost) {
                        media.unreadMessages += 1;
                        media.sendMediaMessageGhost(
                          firstMessage: firstMessage,
                          currentUser: currentUser,
                          appUser: appUser,
                          notificationText: appText(context)
                              .strUnReadAttachment(media.unreadMessages),
                          mediaType: media.photosList.isNotEmpty
                              ? 'InChatPic'
                              : media.videosList.isNotEmpty
                                  ? 'InChatVideo'
                                  : media.mediaList.isNotEmpty
                                      ? 'InChatDoc'
                                      : 'InChatMusic',
                        );
                      } else {
                        media.unreadMessages += 1;
                        media.sendMediaMessage(
                          currentUser: currentUser,
                          appUser: appUser,
                          notificationText: appText(context)
                              .strUnReadAttachment(media.unreadMessages),
                        );
                      }
                    },
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(
                    color: colorWhite,
                    width: 1.h,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(
                    color: colorWhite,
                    width: 1.h,
                  ),
                ),
              ),
            ),
          ),
          heightBox(30.h),
        ],
      ),
    );
  }
}
