import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:video_player/video_player.dart';

import '../../../widgets/chat_screen_widgets/chat_post_tile.dart';
import '../../../widgets/chat_screen_widgets/chat_story_tile.dart';
import '../../../widgets/chat_screen_widgets/chat_tile.dart';
import '../../models/message.dart';
import '../../screens/home/post_detail_screen.dart';

class MessageTiles extends StatelessWidget {
  const MessageTiles({Key? key, required this.message, required this.isMe})
      : super(key: key);

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case "Photo":
        final prePost = message.content;
        final postModel = PostModel.fromMap(prePost);
        return InkWell(
          onTap: () => Get.to(() => PostDetailScreen(
                postModel: postModel,
              )),
          child: ChatPostTile(
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
          child: ChatPostTile(
            message: message,
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
          ),
        );

      case 'Video':
        final prePost = message.content;
        final postModel = PostModel.fromMap(prePost);
        // VideoPlayerController videoPlayerController;
        // videoPlayerController =
        //     VideoPlayerController.network(postModel.mediaData[0].link);

        return InkWell(
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
      case 'Music':
        final prePost = message.content;
        final postModel = PostModel.fromMap(prePost);
        return InkWell(
          onTap: () => Get.to(() => PostDetailScreen(
                postModel: postModel,
              )),
          child: ChatMusicTile(
            aspectRatio: 13 / 9,
            appUserId: message.sentToId,
            isSeen: message.isSeen,
            isMe: isMe,
            date: message.createdAt,
            media: postModel.mediaData[0],
          ),
        );
      case 'story-Video':
        final postModel = MediaDetails.fromMap(message.content);
        return ChatVideoTile(
          link: postModel.link,
          appUserId: message.sentToId,
          isSeen: message.isSeen,
          isMe: isMe,
          date: message.createdAt,
        );
      case 'story-Photo':
        return ChatStoryTile(
          message: message,
          appUserId: message.sentToId,
          isSeen: message.isSeen,
          isMe: isMe,
        );
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
