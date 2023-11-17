import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
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
        elevation: 1,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Consumer<List<UserModel>?>(
          builder: (context, users, b) {
            if (users == null) {
              return const Text("---");
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
        catchError: (context, error) =>
            GlobalSnackBar.show(message: error.toString()),
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
                ChatInputFieldGhost(
                  firstMessage: widget.firstMessagebyMe!,
                  currentUser: currentUser,
                  appUser: appUser,
                  onTapSentMessage: () {
                    ghostProvider.checkGhostMode
                        ? chatProvider.sentMessageGhost(
                            currentUser: currentUser,
                            appUser: appUser,
                            firstMessageByMe: widget.firstMessagebyMe)
                        : GlobalSnackBar.show(
                            message:
                                'Please enable ghost message first to send the message');
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
