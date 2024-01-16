import 'package:casarancha/resources/color_resources.dart';
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

import '../../../widgets/chat_screen_widgets/chat_post_tile.dart';
import '../../../widgets/chat_screen_widgets/chat_story_tile.dart';
import '../../../widgets/chat_screen_widgets/chat_tile.dart';
import '../../models/message.dart';
import '../../screens/home/post_detail_screen.dart';
import '../../screens/home/story_view_screen.dart';
import '../custom_dialog.dart';

Future showMessageMennu({context, url, path, friendId, docId}) async {
  await Get.bottomSheet(CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(
          onPressed: () {
            if (url == null || path == null) {
              Get.back();

              GlobalSnackBar.show(
                  message:
                      'Text message cannot be downloaded you can copy them');
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
            text: 'Download Media',
            fontSize: 16.sp,
            color: color221,
            fontWeight: FontWeight.w400,
          )),
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
            text: 'Delete Message',
            fontSize: 16.sp,
            color: colorPrimaryA05,
            fontWeight: FontWeight.w400,
          )),
    ],
    cancelButton: CupertinoActionSheetAction(
      onPressed: () {
        Get.back();
      },
      child: const Text(
        'Cancel',
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
        return InkWell(
          onLongPress: () {
            showMessageMennu(
              context: context,
              url: message.content[0]['link'],
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
        final videos = message.caption.isEmpty
            ? MediaDetails.fromMap(message.content[0])
            : null;
        var media = message.caption.isNotEmpty
            ? null
            : List.generate(message.content.length,
                (index) => MediaDetails.fromMap(message.content[index]));

        return InkWell(
          onLongPress: () {
            showMessageMennu(
              context: context,
              url: videos!.link,
              path: message.type,
              friendId: isMe ? message.sentToId : message.sentById,
              docId: message.id,
            );
          },
          onTap: message.caption.isNotEmpty
              ? () {}
              : () => Get.to(() => FullScreenVideoPlayer(
                    videoLink: media!.first.link,
                  )),
          child: media == null
              ? AspectRatio(
                  aspectRatio: 9 / 13,
                  child: Container(
                    decoration: BoxDecoration(
                        color: colorBlack.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15)),
                    child: centerLoader(),
                  ))
              : ChatVideoTile(
                  key: videos == null ? null : ValueKey(videos.link),
                  mediaLength: media.length > 1 ? media.length : null,
                  link: videos?.link,
                  appUserId: message.sentToId,
                  isSeen: message.isSeen,
                  isMe: isMe,
                  date: message.createdAt,
                ),
        );
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
            link: postModel.mediaData[0].link,
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
            date: message.createdAt,
          ),
        );
      case 'InChatMusic':
        final music = message.caption.isEmpty
            ? MediaDetails.fromMap(message.content[0])
            : null;
        return InkWell(
          onLongPress: () {
            if (music != null) {
              showMessageMennu(
                context: context,
                url: music.link,
                path: message.type,
                friendId: isMe ? message.sentToId : message.sentById,
                docId: message.id,
              );
            }
          },
          child: ChatMusicTile(
            key: music == null ? null : ValueKey(music.link),
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
            date: message.createdAt,
            media: music,
          ),
        );
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

      case 'InChatDoc':
        final doc = message.caption.isNotEmpty
            ? null
            : MediaDetails.fromMap(message.content[0]);
        return InkWell(
          onLongPress: () {
            if (doc != null) {
              showMessageMennu(
                context: context,
                url: doc.link,
                path: message.type,
                friendId: isMe ? message.sentToId : message.sentById,
                docId: message.id,
              );
            }
          },
          child: ChatDocumentTile(
            key: doc == null ? null : ValueKey(doc.link),
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
            date: message.createdAt,
            media: doc,
          ),
        );

      case 'voice':
        final voice = message.caption.isEmpty
            ? MediaDetails.fromMap(message.content[0])
            : null;
        return InkWell(
          onLongPress: () {
            showMessageMennu(
              context: context,
              url: voice!.link,
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
      case 'story-Video':
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
      case 'story-Photo':
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
            );
          },
          child: ChatTile(
            key: ValueKey(message.content),
            message: message.content,
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
            date: message.createdAt,
          ),
        );
      default:
        return Container();
    }
  }
}
