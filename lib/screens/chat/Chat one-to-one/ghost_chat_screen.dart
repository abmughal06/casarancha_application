import 'package:casarancha/models/ghost_message_details.dart';
import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_input_field_ghost.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_screen_message_tiles.dart';
import 'package:casarancha/widgets/chat_screen_widgets/show_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/chat_screen_widgets/chat_user_app_bar.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/text_widget.dart';

class GhostChatScreen2 extends StatefulWidget {
  final String appUserId;
  final CreatorDetails creatorDetails;
  final bool? firstMessagebyMe;
  final GhostMessageDetails? ghostMessageDetails;

  const GhostChatScreen2({
    super.key,
    required this.appUserId,
    required this.creatorDetails,
    this.firstMessagebyMe,
    this.ghostMessageDetails,
  });

  @override
  State<GhostChatScreen2> createState() => _GhostChatScreen2State();
}

class _GhostChatScreen2State extends State<GhostChatScreen2> {
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
            child: Consumer<List<UserModel>?>(
              builder: (context, users, b) {
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
                  firstMessage: widget.firstMessagebyMe!,
                );
              },
            ),
          )
        : GhostScaffold(
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
              elevation: 1,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: StreamProvider.value(
                value: DataProvider().getSingleUser(widget.appUserId),
                catchError: (context, error) => null,
                initialData: null,
                child: Consumer<UserModel?>(
                  builder: (context, user, b) {
                    if (user == null) {
                      return const Text("---");
                    }

                    return widget.firstMessagebyMe!
                        ? ChatScreenUserAppBar(
                            appUserId: widget.appUserId,
                          )
                        : ListTile(
                            onTap: () {
                              GlobalSnackBar.show(
                                message:
                                    appText(context).strProfileGhostMessage,
                              );
                            },
                            horizontalTitleGap: 10,
                            contentPadding: EdgeInsets.zero,
                            title: TextWidget(text: user.ghostName),
                            subtitle: Text(appText(context).strLive),
                            leading: CircleAvatar(
                              backgroundColor: colorF03,
                              child: Image.asset(
                                imgGhostUser,
                              ),
                            ),
                          );
                  },
                ),
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
                    },
                  ),
                ),
              ],
            ),
            body: StreamProvider.value(
              value: DataProvider().messages(
                  getConversationDocId(currentUserUID!, widget.appUserId),
                  true),
              initialData: null,
              catchError: (context, error) => null,
              child: Consumer<List<Message>?>(
                builder: (context, messages, b) {
                  if (messages == null) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  chatProvider.conversationId =
                      getConversationDocId(currentUserUID!, widget.appUserId);

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            if (messages.isNotEmpty &&
                                messages[index].sentById != currentUserUID) {
                              chatProvider.resetMessageCountGhost(
                                messageid: messages[index].id,
                              );
                            }
                            final isMe =
                                messages[index].sentToId == widget.appUserId;
                            var message = messages[index];
                            return MessageTiles(message: message, isMe: isMe);
                          },
                        ),
                      ),
                      ChatInputFieldGhost(
                        firstMessage: widget.firstMessagebyMe!,
                        appUserId: widget.appUserId,
                      )
                    ],
                  );
                },
              ),
            ),
          );
  }
}
