import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/chat_screen_widgets/chat_screen_message_tiles.dart';
import '../../../widgets/chat_screen_widgets/chat_user_app_bar.dart';
import '../../../widgets/common_widgets.dart';

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

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin<ChatScreen> {
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
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(icIosBackArrow),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0.1,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        title: ChatScreenUserAppBar(
          creatorDetails: widget.creatorDetails,
          appUserId: widget.appUserId,
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
                }),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamProvider.value(
            value: DataProvider().messages(widget.appUserId, false),
            initialData: null,
            child: Consumer<List<Message>?>(
              builder: (context, messages, b) {
                if (messages == null) {
                  return const CircularProgressIndicator.adaptive();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    addAutomaticKeepAlives: true,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      final isMe = message.sentToId == widget.appUserId;
                      if (messages.isNotEmpty && message.type == 'Text') {
                        chatProvider.resetMessageCount(
                          currentUserId: currentUser.id,
                          appUserId: appUser.id,
                          messageid: message.id,
                        );
                      }
                      return MessageTiles(
                        isMe: isMe,
                        message: message,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          ChatTextField(
            ontapSend: () {
              chatProvider.sentMessage(
                currentUser: currentUser,
                appUser: appUser,
              );
            },
            chatController: chatProvider.messageController,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
