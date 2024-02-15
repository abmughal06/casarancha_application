import 'dart:io';

import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/chat_screen_widgets/chat_input_field.dart';
import '../../../widgets/chat_screen_widgets/chat_screen_message_tiles.dart';
import '../../../widgets/chat_screen_widgets/chat_user_app_bar.dart';
import '../../../widgets/common_widgets.dart';

class ChatScreen extends StatefulWidget {
  final String appUserId;

  const ChatScreen({
    super.key,
    required this.appUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatProvider chatProvider;

  @override
  void dispose() {
    chatProvider.clearMessageController();
    chatProvider.clearListsondispose();
    chatProvider.recordedFilePath = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context);

    return chatProvider.photosList.isNotEmpty ||
            chatProvider.videosList.isNotEmpty ||
            chatProvider.mediaList.isNotEmpty ||
            chatProvider.musicList.isNotEmpty
        ? StreamProvider.value(
            value: DataProvider()
                .filterUserList([currentUserUID] + [widget.appUserId]),
            initialData: null,
            catchError: (context, error) => null,
            child: Consumer<List<UserModel>?>(builder: (context, users, b) {
              if (users == null) {
                return centerLoader();
              }
              return ShowMediaToSendInChat(
                currentUser: users
                    .where((element) => element.id == currentUserUID)
                    .first,
                appUser: users
                    .where((element) => element.id == widget.appUserId)
                    .first,
              );
            }),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: SvgPicture.asset(icIosBackArrow),
                onPressed: () {
                  Get.back();
                },
              ),
              elevation: 1,
              automaticallyImplyLeading: false,
              backgroundColor: colorWhite,
              title: ChatScreenUserAppBar(
                // creatorDetails: widget.creatorDetails,
                appUserId: widget.appUserId,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: svgImgButton(
                      svgIcon: icChatVideo,
                      onTap: () {
                        GlobalSnackBar.show(
                            message: appText(context).strComingSoon);
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.w, right: 20.w),
                  child: svgImgButton(
                      svgIcon: icChatCall,
                      onTap: () {
                        GlobalSnackBar.show(
                            message: appText(context).strComingSoon);
                      }),
                ),
              ],
            ),
            body: StreamProvider.value(
              value: DataProvider().messages(widget.appUserId, false),
              initialData: null,
              catchError: (context, error) => null,
              child: Consumer<List<Message>?>(
                builder: (context, messages, b) {
                  if (messages == null) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length,
                          reverse: true,
                          padding: const EdgeInsets.only(top: 12),
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            final isMe = message.sentToId == widget.appUserId;
                            if (messages.isNotEmpty) {
                              chatProvider.resetMessageCount(
                                currentUserId:
                                    FirebaseAuth.instance.currentUser!.uid,
                                appUserId: widget.appUserId,
                                messageid: message.id,
                              );
                            }
                            return MessageTiles(
                              isMe: isMe,
                              message: message,
                            );
                          },
                        ),
                      ),
                      ChatInputField(
                        appUserId: widget.appUserId,
                      ),
                    ],
                  );
                },
              ),
            ),
            floatingActionButton:
                Consumer<ChatProvider>(builder: (context, v, b) {
              if (v.isRecording && !v.isRecorderLock) {
                return Padding(
                  padding: EdgeInsets.only(bottom: Platform.isIOS ? 50 : 80),
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () {},
                    backgroundColor: colorWhite,
                    child: SvgPicture.asset(icSelectLock),
                  ),
                );
              }
              return Container();
            }),
          );
  }
}
