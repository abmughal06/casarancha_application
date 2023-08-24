import 'dart:math';

import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';

import 'package:casarancha/utils/app_utils.dart';
import 'package:casarancha/widgets/chat_screen_widgets/full_screen_chat_media.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_model.dart';

import '../../../widgets/chat_screen_widgets/chat_post_tile.dart';
import '../../../widgets/chat_screen_widgets/chat_story_tile.dart';
import '../../../widgets/chat_screen_widgets/chat_tile.dart';
import '../../models/message.dart';
import '../../screens/dashboard/provider/download_provider.dart';
import '../../screens/home/post_detail_screen.dart';
import '../../screens/home/story_view_screen.dart';
import '../custom_dialog.dart';

class MessageTiles extends StatelessWidget {
  const MessageTiles({Key? key, required this.message, required this.isMe})
      : super(key: key);

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case "InChatPic":
        return InkWell(
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDownloadDialog(
                    url: message.content[0]['link'],
                    path:
                        '${message.type}_${Random().nextInt(2)}${checkMediaTypeAndSetExtention(message.type)}',
                  );
                });
          },
          onTap: () => Get.to(() => ChatMediaFullScreenView(
                media: List.generate(message.content.length,
                    (index) => MediaDetails.fromMap(message.content[index])),
              )),
          child: ChatImageTile(
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
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDownloadDialog(
                    url: message.content['mediaData'][0]['link'],
                    path:
                        '${message.type}_${Random().nextInt(2)}${checkMediaTypeAndSetExtention(message.type)}',
                  );
                });
          },
          onTap: () => Get.to(() => PostDetailScreen(
                postModel: postModel,
              )),
          child: ChatPostTile(
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
          onTap: () => Get.to(() => PostDetailScreen(
                postModel: postModel,
              )),
          child: ChatQouteTile(
            message: message,
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
          ),
        );
      case 'InChatVideo':
        final prePost = message.content;
        final postModel = MediaDetails.fromMap(prePost[0]);
        var media = List.generate(message.content.length,
            (index) => MediaDetails.fromMap(message.content[index]));

        return InkWell(
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDownloadDialog(
                    url: postModel.link,
                    path:
                        '${message.type}_${Random().nextInt(2)}${checkMediaTypeAndSetExtention(message.type)}',
                  );
                });
          },
          onTap: () => Get.to(() => ChatMediaFullScreenView(
                media: media,
              )),
          child: ChatVideoTile(
            mediaLength: media.length > 1 ? media.length : null,
            link: postModel.link,
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
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDownloadDialog(
                    url: postModel.mediaData[0].link,
                    path:
                        '${message.type}_${Random().nextInt(2)}${checkMediaTypeAndSetExtention(message.type)}',
                  );
                });
          },
          onTap: () => Get.to(() => PostDetailScreen(
                postModel: postModel,
              )),
          child: ChatVideoTile(
            link: postModel.mediaData[0].link,
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
            date: message.createdAt,
          ),
        );
      case 'InChatMusic':
        final music = MediaDetails.fromMap(message.content[0]);
        return InkWell(
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDownloadDialog(
                    url: message.content[0]['link'],
                    path:
                        '${message.type}_${Random().nextInt(2)}${checkMediaTypeAndSetExtention(message.type)}',
                  );
                });
          },
          child: ChatMusicTile(
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
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDownloadDialog(
                    url: postModel.mediaData[0].link,
                    path:
                        '${message.type}_${Random().nextInt(2)}${checkMediaTypeAndSetExtention(message.type)}',
                  );
                });
          },
          onTap: () => Get.to(() => PostDetailScreen(
                postModel: postModel,
              )),
          child: ChatMusicTile(
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
            date: message.createdAt,
            media: postModel.mediaData[0],
          ),
        );

      case 'InChatDoc':
        final prePost = message.content[0];
        final postModel = MediaDetails.fromMap(prePost);
        return ChatDocumentTile(
          appUserId: message.sentToId,
          isSeen: message.isSeen,
          isMe: isMe,
          date: message.createdAt,
          media: postModel,
        );

      case 'voice':
        final voice = MediaDetails.fromMap(message.content[0]);
        return ChatMusicTile(
          appUserId: message.sentToId,
          isSeen: message.isSeen,
          isMe: isMe,
          date: message.createdAt,
          media: voice,
        );
      case 'story-Video':
        final postModel = MediaDetails.fromMap(message.content);
        return isDateAfter24Hour(DateTime.parse(message.createdAt))
            ? ChatVideoTile(
                link: postModel.link,
                appUserId: message.sentToId,
                isSeen: message.isSeen,
                isMe: isMe,
                date: message.createdAt,
              )
            : Container();
      case 'story-Photo':
        return isDateAfter24Hour(DateTime.parse(message.createdAt))
            ? ChatStoryTile(
                message: message,
                appUserId: message.sentToId,
                isSeen: message.isSeen,
                isMe: isMe,
              )
            : Container();
      case 'Text':
        return ChatTile(
          message: message.content,
          appUserId: message.sentToId,
          isSeen: message.isSeen,
          isMe: isMe,
          date: message.createdAt,
        );
      default:
        return Container();
    }
  }
}
