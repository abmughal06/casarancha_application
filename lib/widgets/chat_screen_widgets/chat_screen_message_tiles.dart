import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/chat_screen_widgets/full_screen_chat_media.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/full_screen_video_player.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../widgets/chat_screen_widgets/chat_post_tile.dart';
import '../../../widgets/chat_screen_widgets/chat_story_tile.dart';
import '../../../widgets/chat_screen_widgets/chat_tile.dart';
import '../../models/message.dart';
import '../../screens/home/post_detail_screen.dart';
import '../../screens/home/story_view_screen.dart';
import '../custom_dialog.dart';

Future showMessageMennu({context, url, path, friendId, docId, text}) async {
  final chatProvider = Provider.of<ChatProvider>(context, listen: false);
  final ghost = Provider.of<DashboardProvider>(context, listen: false);
  await Get.bottomSheet(CupertinoActionSheet(
    actions: [
      if (url != null || path != null)
        CupertinoActionSheetAction(
          onPressed: () {
            if (url == null || path == null) {
              Get.back();

              GlobalSnackBar.show(
                  message: appText(context).strcannotDownloadText);
            } else {
              Get.back();
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDownloadDialog(
                      url: url,
                      path: path,
                    );
                  });
            }
          },
          child: TextWidget(
            text: appText(context).btnDownloadMedia,
            fontSize: 16.sp,
            color: color221,
            fontWeight: FontWeight.w400,
          ),
        ),
      CupertinoActionSheetAction(
        onPressed: () {
          if (url == null || path == null) {
            Get.back();
            Share.share('$text');
          } else {
            Get.back();
            Share.shareUri(Uri.parse(url));
          }
        },
        child: TextWidget(
          text: appText(context).strShare,
          fontSize: 16.sp,
          color: color221,
          fontWeight: FontWeight.w400,
        ),
      ),
      if (url == null || path == null)
        CupertinoActionSheetAction(
          onPressed: () async {
            Get.back();
            await chatProvider.enableEditing(docId, ghost.checkGhostMode);
          },
          child: TextWidget(
            text: appText(context).edit,
            fontSize: 16.sp,
            color: color221,
            fontWeight: FontWeight.w400,
          ),
        ),
      CupertinoActionSheetAction(
        onPressed: () {
          Get.back();
          showDialog(
              context: context,
              builder: (context) {
                return CustomDeleteDialog(
                  friendId: friendId,
                  docId: docId,
                  isUnsend: true,
                );
              });
        },
        child: TextWidget(
          text: appText(context).unSendMessage,
          fontSize: 16.sp,
          color: colorPrimaryA05,
          fontWeight: FontWeight.w400,
        ),
      ),
      CupertinoActionSheetAction(
        onPressed: () {
          Get.back();
          showDialog(
              context: context,
              builder: (context) {
                return CustomDeleteDialog(
                  friendId: friendId,
                  docId: docId,
                );
              });
        },
        child: TextWidget(
          text: appText(context).btnDeleteMsg,
          fontSize: 16.sp,
          color: colorPrimaryA05,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      onPressed: () {
        Get.back();
      },
      child: Text(
        appText(context).strCancel,
      ),
    ),
  ));
}

class MessageTiles extends StatelessWidget {
  const MessageTiles({super.key, required this.message, required this.isMe});

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case "InChatPic":
        final pic = message.content != 'upload'
            ? MediaDetails.fromMap(message.content[0])
            : null;
        return InkWell(
          onLongPress: () {
            showMessageMennu(
              context: context,
              url: pic == null ? "" : pic.link,
              path: message.type,
              friendId: isMe ? message.sentToId : message.sentById,
              docId: message.id,
            );
          },
          onTap: message.caption.isNotEmpty
              ? () {}
              : () => Get.to(() => ChatMediaFullScreenView(
                    media: List.generate(
                        message.content.length,
                        (index) =>
                            MediaDetails.fromMap(message.content[index])),
                  )),
          child: ChatImageTile(
            key: ValueKey(message.createdAt),
            message: message,
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
          ),
        );

      case "Photo":
        final prePost = message.content;
        final postModel = PostModel.fromMap(prePost);
        return InkWell(
          onLongPress: () {
            showMessageMennu(
              context: context,
              url: message.content['mediaData'][0]['link'],
              path: message.type,
              friendId: isMe ? message.sentToId : message.sentById,
              docId: message.id,
            );
          },
          onTap: () => Get.to(() => PostDetailScreen(
                postModel: postModel,
                groupId: postModel.groupId,
              )),
          child: ChatPostTile(
            key: ValueKey(postModel.mediaData.first.link),
            imageUrl: message.content['mediaData'][0]['link'],
            message: message,
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
          ),
        );
      case 'Qoute':
        final prePost = message.content;
        final postModel = PostModel.fromMap(prePost);
        return InkWell(
          onLongPress: () {
            showMessageMennu(
              context: context,
              url: postModel.mediaData.first.link,
              path: message.type,
              friendId: isMe ? message.sentToId : message.sentById,
              docId: message.id,
            );
          },
          onTap: () => Get.to(() => PostDetailScreen(
                postModel: postModel,
                groupId: postModel.groupId,
              )),
          child: ChatQouteTile(
            key: ValueKey(postModel.mediaData.first.link),
            message: message,
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
          ),
        );
      case 'InChatVideo':
        final videos = message.content != 'upload'
            ? MediaDetails.fromMap(message.content[0])
            : null;
        var media = message.content == "upload"
            ? null
            : List.generate(message.content.length,
                (index) => MediaDetails.fromMap(message.content[index]));
        final isUploading = media == null && !isMe;

        return !isUploading
            ? InkWell(
                onLongPress: () {
                  showMessageMennu(
                    context: context,
                    url: videos == null ? "" : videos.link,
                    path: message.type,
                    friendId: isMe ? message.sentToId : message.sentById,
                    docId: message.id,
                  );
                },
                onTap: message.content != 'upload'
                    ? () {}
                    : () => Get.to(() => FullScreenVideoPlayer(
                          videoLink: media!.first.link,
                        )),
                child: media == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: isMe
                                  ? MediaQuery.of(context).size.width * .5
                                  : 0,
                              right: isMe
                                  ? 0
                                  : MediaQuery.of(context).size.width * .5,
                              bottom: 10),
                          child: Align(
                            alignment:
                                isMe ? Alignment.topRight : Alignment.topLeft,
                            child: AspectRatio(
                              aspectRatio: 9 / 13,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: colorBlack.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: centerLoader(),
                              ),
                            ),
                          ),
                        ),
                      )
                    : ChatVideoTile(
                        key: videos == null ? null : ValueKey(videos.link),
                        mediaLength: media.length > 1 ? media.length : null,
                        media: videos,
                        appUserId: message.sentToId,
                        isSeen: message.isSeen,
                        caption: message.caption,
                        isMe: isMe,
                        date: message.createdAt,
                      ),
              )
            : widthBox(0);
      case 'Video':
        final prePost = message.content;
        final postModel = PostModel.fromMap(prePost);
        return InkWell(
          onLongPress: () {
            showMessageMennu(
              context: context,
              url: postModel.mediaData.first.link,
              path: message.type,
              friendId: isMe ? message.sentToId : message.sentById,
              docId: message.id,
            );
          },
          onTap: () => Get.to(() => FullScreenVideoPlayer(
                videoLink: postModel.mediaData.first.link,
              )),
          child: ChatVideoTile(
            key: ValueKey(postModel.mediaData.first.link),
            media: postModel.mediaData[0],
            appUserId: message.sentToId,
            caption: null,
            isSeen: message.isSeen,
            isMe: isMe,
            date: message.createdAt,
          ),
        );
      case 'InChatMusic':
        final music = message.content != 'upload'
            ? MediaDetails.fromMap(message.content[0])
            : null;
        final isUploading = music == null && !isMe;

        return !isUploading
            ? InkWell(
                onLongPress: () {
                  showMessageMennu(
                    context: context,
                    url: music == null ? "" : music.link,
                    path: message.type,
                    friendId: isMe ? message.sentToId : message.sentById,
                    docId: message.id,
                  );
                },
                child: ChatMusicTile(
                  key: music == null ? null : ValueKey(music.link),
                  appUserId: message.sentToId,
                  isSeen: message.isSeen,
                  isMe: isMe,
                  caption: message.caption,
                  date: message.createdAt,
                  media: music,
                ),
              )
            : widthBox(0);
      case 'Music':
        final prePost = message.content;
        final postModel = PostModel.fromMap(prePost);
        return InkWell(
          onLongPress: () {
            showMessageMennu(
              context: context,
              url: postModel.mediaData.first.link,
              path: message.type,
              friendId: isMe ? message.sentToId : message.sentById,
              docId: message.id,
            );
          },
          onTap: () => Get.to(() => PostDetailScreen(
                postModel: postModel,
                groupId: postModel.groupId,
              )),
          child: ChatMusicTile(
            key: ValueKey(postModel.mediaData.first.link),
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
            date: message.createdAt,
            media: postModel.mediaData[0],
          ),
        );

      case 'Doc':
        final doc = message.content == 'upload'
            ? null
            : MediaDetails.fromMap(message.content[0]);
        final isUploading = doc == null && !isMe;

        return isUploading
            ? widthBox(0)
            : InkWell(
                onLongPress: () {
                  showMessageMennu(
                    context: context,
                    url: doc == null ? '' : doc.link,
                    path: message.type,
                    friendId: isMe ? message.sentToId : message.sentById,
                    docId: message.id,
                  );
                },
                child: ChatDocumentTile(
                  key: doc == null ? null : ValueKey(doc.link),
                  appUserId: message.sentToId,
                  isSeen: message.isSeen,
                  caption: message.caption,
                  isMe: isMe,
                  date: message.createdAt,
                  media: doc,
                ),
              );

      case 'Voice':
        final voice = message.caption.isEmpty
            ? MediaDetails.fromMap(message.content[0])
            : null;
        final isUploading = voice == null && !isMe;

        return isUploading
            ? widthBox(0)
            : InkWell(
                onLongPress: () {
                  showMessageMennu(
                    context: context,
                    url: voice == null ? '' : voice.link,
                    path: message.type,
                    friendId: isMe ? message.sentToId : message.sentById,
                    docId: message.id,
                  );
                },
                child: ChatVoiceTile(
                  key: voice != null ? ValueKey(voice.link) : null,
                  appUserId: message.sentToId,
                  isSeen: message.isSeen,
                  isMe: isMe,
                  date: message.createdAt,
                  media: voice,
                ),
              );
      case 'StoryVideo':
        final story = MediaDetails.fromMap(message.content);
        return isDateAfter24Hour(DateTime.parse(message.createdAt))
            ? InkWell(
                onLongPress: () {
                  showMessageMennu(
                    context: context,
                    url: story.link,
                    path: message.type,
                    friendId: isMe ? message.sentToId : message.sentById,
                    docId: message.id,
                  );
                },
                onTap: () => Get.to(() => FullScreenVideoPlayer(
                      videoLink: story.link,
                    )),
                child: ChatStoryVideoTile(
                  key: ValueKey(story.link),
                  link: story.link,
                  appUserId: message.sentToId,
                  isSeen: message.isSeen,
                  isMe: isMe,
                  date: message.createdAt,
                  message: message.caption,
                ),
              )
            : Container();
      case 'StoryPic':
        return isDateAfter24Hour(DateTime.parse(message.createdAt))
            ? InkWell(
                onLongPress: () {
                  showMessageMennu(
                    context: context,
                    url: message.content['link'],
                    path: message.type,
                    friendId: isMe ? message.sentToId : message.sentById,
                    docId: message.id,
                  );
                },
                onTap: () => Get.to(() => ChatMediaFullScreenView(
                      media: [MediaDetails.fromMap(message.content)],
                    )),
                child: ChatStoryTile(
                  key: ValueKey(message.content),
                  message: message,
                  appUserId: message.sentToId,
                  isSeen: message.isSeen,
                  isMe: isMe,
                ),
              )
            : Container();
      case 'Text':
        return InkWell(
          onLongPress: () {
            showMessageMennu(
              context: context,
              url: null,
              path: null,
              friendId: isMe ? message.sentToId : message.sentById,
              docId: message.id,
              text: message.content,
            );
          },
          child: ChatTile(
            key: ValueKey(message.content),
            message: message,
            appUserId: message.sentToId,
            isMe: isMe,
          ),
        );
      default:
        return widthBox(0);
    }
  }
}
