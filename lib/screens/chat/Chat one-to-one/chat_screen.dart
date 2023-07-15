import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../resources/image_resources.dart';
import '../../../widgets/chat_screen_widgets/chat_post_tile.dart';
import '../../../widgets/chat_screen_widgets/chat_story_tile.dart';
import '../../../widgets/chat_screen_widgets/chat_tile.dart';
import '../../../widgets/common_widgets.dart';
import '../../home/post_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  final String appUserId;
  final CreatorDetails creatorDetails;
  final String? val;

  const ChatScreen({
    Key? key,
    required this.appUserId,
    required this.creatorDetails,
    this.val,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: ListTile(
          onTap: () {},
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Text(
                            widget.creatorDetails.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        WidgetSpan(child: widthBox(5.w)),
                        WidgetSpan(
                          child: Visibility(
                              visible: widget.creatorDetails.isVerified,
                              child: SvgPicture.asset(icVerifyBadge)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          subtitle: const Text('Live'),
          leading: CircleAvatar(
            backgroundImage: widget.creatorDetails.imageUrl.isNotEmpty
                ? CachedNetworkImageProvider(
                    widget.creatorDetails.imageUrl,
                  )
                : null,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: svgImgButton(
                svgIcon: icChatVideo,
                onTap: () {
                  // Get.to(
                  //   () => const VideoCallScreen(),
                  // );
                  GlobalSnackBar.show(message: "Comming Soon");
                }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 20.w),
            child: svgImgButton(
                svgIcon: icChatCall,
                onTap: () {
                  // Get.to(
                  //   () => const AudioCallScreen(),
                  // );
                  GlobalSnackBar.show(message: "Comming Soon");
                }),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<List<Message>?>(
            stream: DataProvider().messages(widget.appUserId),
            builder: (context, messages) {
              if (messages.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: messages.data!.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = messages.data![index];

                      final isMe = message.sentToId == widget.appUserId;
                      final isSeen = message.isSeen;

                      if (message.type == "Photo" || message.type == "Qoute") {
                        final prePost = message.content;
                        final postModel = PostModel.fromMap(prePost);
                        return InkWell(
                          onTap: () => Get.to(() => PostDetailScreen(
                                postModel: postModel,
                              )),
                          child: ChatPostTile(
                            message: message,
                            appUserId: widget.appUserId,
                            isSeen: isSeen,
                            isMe: isMe,
                          ),
                        );
                      } else if (message.type == "Text") {
                        return ChatTile(
                          message: message.content,
                          appUserId: widget.appUserId,
                          isSeen: message.isSeen,
                          isMe: isMe,
                          date: message.createdAt,
                        );
                      } else if (message.type == "Video") {
                        final prePost = message.content;
                        final postModel = PostModel.fromMap(prePost);
                        VideoPlayerController videoPlayerController;
                        videoPlayerController = VideoPlayerController.network(
                            postModel.mediaData[0].link);
                        videoPlayerController.initialize();
                        videoPlayerController.pause();
                        return InkWell(
                          onTap: () => Get.to(() => PostDetailScreen(
                                postModel: postModel,
                              )),
                          child: ChatVideoTile(
                            aspectRatio:
                                videoPlayerController.value.aspectRatio,
                            appUserId: widget.appUserId,
                            isSeen: message.isSeen,
                            isMe: isMe,
                            date: message.createdAt,
                            videoPlayerController: videoPlayerController,
                          ),
                        );
                      } else if (message.type == "Music") {
                        final prePost = message.content;
                        final postModel = PostModel.fromMap(prePost);

                        return InkWell(
                          onTap: () => Get.to(() => PostDetailScreen(
                                postModel: postModel,
                              )),
                          child: ChatMusicTile(
                            aspectRatio: 13 / 9,
                            appUserId: widget.appUserId,
                            isSeen: message.isSeen,
                            isMe: isMe,
                            date: message.createdAt,
                            media: postModel.mediaData[0],
                          ),
                        );
                      } else if (message.type == "story-Video") {
                        final postModel = MediaDetails.fromMap(message.content);
                        VideoPlayerController videoPlayerController;
                        videoPlayerController =
                            VideoPlayerController.network(postModel.link);
                        videoPlayerController.initialize();
                        videoPlayerController.pause();
                        return ChatVideoTile(
                          aspectRatio: videoPlayerController.value.aspectRatio,
                          appUserId: widget.appUserId,
                          isSeen: message.isSeen,
                          isMe: isMe,
                          date: message.createdAt,
                          videoPlayerController: videoPlayerController,
                        );
                      } else if (message.type == "story-Photo") {
                        return ChatStoryTile(
                          message: message,
                          appUserId: widget.appUserId,
                          isSeen: isSeen,
                          isMe: isMe,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          ChatTextField(ontapSend: () {}, chatController: chatController),
        ],
      ),
    );
  }
}
