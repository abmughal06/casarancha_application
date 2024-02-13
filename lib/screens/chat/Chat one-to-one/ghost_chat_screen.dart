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

  const GhostChatScreen2({
    super.key,
    required this.appUserId,
    required this.creatorDetails,
    this.firstMessagebyMe,
  });

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
                          message: appText(context).strProfileGhostMessage,
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
                  GlobalSnackBar.show(message: appText(context).strComingSoon);
                }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 20.w),
            child: svgImgButton(
              svgIcon: icChatCall,
              onTap: () {
                GlobalSnackBar.show(message: appText(context).strComingSoon);
              },
            ),
          ),
        ],
      ),
      body: StreamProvider.value(
        value: DataProvider().messages(widget.appUserId, true),
        initialData: null,
        catchError: (context, error) => null,
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
                          currentUserId: currentUserUID,
                          appUserId: widget.appUserId,
                          messageid: messages[index].id,
                        );
                      }
                      final isMe = messages[index].sentToId == widget.appUserId;
                      var message = messages[index];
                      return MessageTiles(message: message, isMe: isMe);
                    },
                  ),
                ),
                ChatInputFieldGhost(
                  firstMessage: widget.firstMessagebyMe!,
                  appUserId: widget.appUserId,
                  // currentUser: currentUser,
                  // appUser: appUser,
                  // onTapSentMessage: () {
                  //
                  // },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
