import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_screen_message_tiles.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/chat_screen_widgets/chat_user_app_bar.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/text_widget.dart';
import 'chat_screen.dart';

class GhostChatScreen2 extends StatefulWidget {
  final String appUserId;
  final CreatorDetails creatorDetails;
  final bool? firstMessagebyMe;

  const GhostChatScreen2({
    Key? key,
    required this.appUserId,
    required this.creatorDetails,
    this.firstMessagebyMe,
  }) : super(key: key);

  @override
  State<GhostChatScreen2> createState() => _GhostChatScreen2State();
}

class _GhostChatScreen2State extends State<GhostChatScreen2> {
  late ChatProvider chatProvider;
  @override
  void dispose() {
    chatProvider.clearMessageController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final currentUser = context.watch<UserModel>();
    final users = context.watch<List<UserModel>>();
    final appUser =
        users.where((element) => element.id == widget.appUserId).first;
    final ghostProvider = context.watch<DashboardProvider>();
    return GhostScaffold(
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
        title: Consumer<List<UserModel>?>(
          builder: (context, users, b) {
            if (users == null) {
              return const Text("--");
            }
            var appUser =
                users.where((element) => element.id == widget.appUserId).first;
            return widget.firstMessagebyMe!
                ? ChatScreenUserAppBar(
                    creatorDetails: widget.creatorDetails,
                    appUserId: widget.appUserId,
                  )
                : ListTile(
                    onTap: () {
                      GlobalSnackBar.show(
                        message:
                            "you can't see sender profile in ghost messages",
                      );
                    },
                    horizontalTitleGap: 10,
                    contentPadding: EdgeInsets.zero,
                    title: TextWidget(text: appUser.ghostName),
                    subtitle: const Text('Live'),
                    leading: CircleAvatar(
                      backgroundColor: colorF03,
                      child: Image.asset(
                        imgGhostUser,
                      ),
                    ),
                  );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: svgImgButton(
                svgIcon: icChatVideo,
                onTap: () {
                  GlobalSnackBar.show(message: "Comming Soon");
                }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 20.w),
            child: svgImgButton(
              svgIcon: icChatCall,
              onTap: () {
                GlobalSnackBar.show(message: "Comming Soon");
              },
            ),
          ),
        ],
      ),
      body: StreamProvider.value(
        value: DataProvider().messages(widget.appUserId, true),
        initialData: null,
        child: Consumer<List<Message>?>(
          builder: (context, messages, b) {
            if (messages == null) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      if (messages.isNotEmpty) {
                        chatProvider.resetMessageCountGhost(
                            currentUserId: currentUser.id,
                            appUserId: appUser.id,
                            messageid: messages[index].id);
                      }
                      final isMe = messages[index].sentToId == widget.appUserId;
                      var message = messages[index];
                      return MessageTiles(message: message, isMe: isMe);
                    },
                  ),
                ),
                Consumer<ChatProvider>(
                  builder: (context, v, b) {
                    return v.voiceFile == null
                        ? chatProvider.photosList.isNotEmpty ||
                                chatProvider.videosList.isNotEmpty ||
                                chatProvider.musicList.isNotEmpty
                            ? ShowMediaToSendInChat(
                                currentUser: currentUser,
                                appUser: appUser,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: colorWhite,
                                    border: Border(
                                        top: BorderSide(
                                            color: color221.withOpacity(0.3)))),
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 35, top: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ChatTextField(
                                        chatController:
                                            chatProvider.messageController,
                                        ontapSend: () {},
                                      ),
                                    ),
                                    Visibility(
                                      visible: chatProvider
                                          .messageController.text.isEmpty,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // widthBox(8.w),
                                          SpeedDial(
                                            closeDialOnPop: true,
                                            backgroundColor: Colors.transparent,
                                            activeBackgroundColor:
                                                colorPrimaryA05,
                                            activeChild: const Icon(
                                              Icons.close,
                                              color: colorWhite,
                                            ),
                                            buttonSize: Size(40.h, 40.h),
                                            overlayColor: Colors.black,
                                            overlayOpacity: 0.4,
                                            elevation: 0,
                                            spacing: 5,
                                            childMargin: EdgeInsets.zero,
                                            children: [
                                              SpeedDialChild(
                                                child: Icon(
                                                  Icons
                                                      .photo_size_select_actual_rounded,
                                                  size: 18.sp,
                                                ),
                                                onTap: () {
                                                  chatProvider.getPhoto();
                                                },
                                                label: 'Image',
                                              ),
                                              SpeedDialChild(
                                                child: Icon(
                                                  Icons.video_collection_sharp,
                                                  size: 18.sp,
                                                ),
                                                onTap: () {
                                                  chatProvider.getVideo();
                                                },
                                                label: 'Video',
                                              ),
                                              SpeedDialChild(
                                                child: Icon(
                                                  Icons.music_note_outlined,
                                                  size: 20.sp,
                                                ),
                                                onTap: () {
                                                  chatProvider.getMusic();
                                                },
                                                label: 'Music',
                                              ),
                                            ],
                                            child: SvgPicture.asset(
                                              icChatPaperClip,
                                              height: 25.h,
                                              color: color221,
                                            ),
                                          ),
                                          // widthBox(8.w),
                                          Container(
                                            padding: EdgeInsets.all(9.w),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    colorF03.withOpacity(0.6)),
                                            child: const Icon(
                                              Icons.mic_none_sharp,
                                              color: color221,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      child: Visibility(
                                        visible: chatProvider
                                            .messageController.text.isNotEmpty,
                                        child: Row(
                                          children: [
                                            widthBox(12.w),
                                            GestureDetector(
                                              onTap: () {
                                                ghostProvider.checkGhostMode
                                                    ? chatProvider.sentMessageGhost(
                                                        currentUser:
                                                            currentUser,
                                                        appUser: appUser,
                                                        firstMessageByMe: widget
                                                            .firstMessagebyMe)
                                                    : GlobalSnackBar.show(
                                                        message:
                                                            'Please enable ghost message first to send the message');
                                              },
                                              child: Image.asset(
                                                imgSendComment,
                                                height: 38.h,
                                                width: 38.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                        : VoiceRecordingPlayer(voiceFile: v.voiceFile!);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
