import 'dart:io';

import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/chat_screen_widgets/show_media_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/chat_screen_widgets/chat_input_field.dart';
import '../../../widgets/chat_screen_widgets/chat_screen_message_tiles.dart';
import '../../../widgets/chat_screen_widgets/chat_user_app_bar.dart';
import '../../../widgets/common_widgets.dart';

class ChatScreen extends StatefulWidget {
  final String appUserId;

  const ChatScreen({super.key, required this.appUserId});

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

  String? appUserName;

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context);
    chatProvider.setUserName(widget.appUserId);

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
                appUserId: widget.appUserId,
              ),
              actions: [
                PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: color080,
                  ),
                  itemBuilder: (_) {
                    return [
                      PopupMenuItem(
                          child: IconButton(
                              onPressed: () {
                                GlobalSnackBar.show(
                                    message: appText(context).strComingSoon);
                              },
                              icon: SvgPicture.asset(icChatVideo))),
                      PopupMenuItem(
                          child: IconButton(
                              onPressed: () {
                                GlobalSnackBar.show(
                                    message: appText(context).strComingSoon);
                              },
                              icon: SvgPicture.asset(icChatCall)))
                    ];
                  },
                )
              ],
            ),
            body: SafeArea(
              bottom: true,
              top: false,
              child: StreamProvider.value(
                value: DataProvider().messages(
                    getConversationDocId(currentUserUID!, widget.appUserId),
                    false),
                initialData: null,
                catchError: (context, error) => null,
                child: Consumer<List<Message>?>(
                  builder: (context, messages, b) {
                    if (messages == null) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }

                    chatProvider.conversationId =
                        getConversationDocId(currentUserUID!, widget.appUserId);

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
                              if (messages.isNotEmpty &&
                                  message.sentById != currentUserUID) {
                                chatProvider.resetMessageCount(
                                  messageid: message.id,
                                );
                              }
                              return SwipeTo(
                                key: ValueKey(message),
                                iconOnLeftSwipe: Icons.arrow_forward,
                                iconOnRightSwipe: Icons.arrow_back,
                                onRightSwipe: (details) {
                                  chatProvider.enableReply(message);
                                },
                                onLeftSwipe: (details) {
                                  chatProvider.enableReply(message);
                                },
                                // swipeSensitivity: 20,
                                child: MessageTiles(
                                  isMe: isMe,
                                  message: message,
                                ),
                              );
                            },
                          ),
                        ),
                        Column(
                          children: [
                            if (chatProvider.isReply)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: colorFF4,
                                        borderRadius: BorderRadius.circular(12),
                                        border: const Border(
                                          left: BorderSide(
                                              color: colorPrimaryA05, width: 6),
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                      ),
                                      padding: const EdgeInsets.all(
                                        10,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            text: chatProvider.replyingMessage!
                                                        .sentToId ==
                                                    widget.appUserId
                                                ? "You"
                                                : chatProvider.appUserName,
                                            fontWeight: FontWeight.w600,
                                            color: colorPrimaryA05,
                                          ),
                                          TextWidget(
                                            text: chatProvider.replyingMessage!
                                                        .type ==
                                                    'Text'
                                                ? chatProvider
                                                    .replyingMessage!.content
                                                    .toString()
                                                : chatProvider.getMediaType(
                                                    chatProvider
                                                        .replyingMessage!.type),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        chatProvider.disableReply();
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: colorPrimaryA05,
                                      )),
                                ],
                              ),
                            ChatInputField(
                              appUserId: widget.appUserId,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            floatingActionButton:
                Consumer<ChatProvider>(builder: (context, v, b) {
              if (v.isRecording && !v.isRecorderLock) {
                return Padding(
                  padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 50),
                  child: CircleAvatar(
                    backgroundColor: colorWhite,
                    radius: 20,
                    child: SvgPicture.asset(icSelectLock),
                  ),
                );
              }
              return Container();
            }),
          );
  }
}
