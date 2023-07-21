import 'dart:math';

import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/ghost_chat_screen.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_user_list_tile.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../models/ghost_message_details.dart';

class MessageListGhost extends StatefulWidget {
  const MessageListGhost({Key? key}) : super(key: key);

  @override
  State<MessageListGhost> createState() => _MessageListGhostState();
}

class _MessageListGhostState extends State<MessageListGhost> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: searchTextField(
            context: context,
            controller: TextEditingController(),
            onChange: (value) {
              // chatListController.searchQuery.value = value;
            },
          ),
        ),
        heightBox(10.h),
        const Expanded(child: GhostChatList())
      ],
    );
  }
}

class GhostChatList extends StatelessWidget {
  const GhostChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> messageUserIds = [];
    return ListView(
      children: [
        Consumer<List<GhostMessageDetails>?>(
          builder: (context, messages, b) {
            if (messages == null) {
              return Container();
            } else {
              log(messages.length);
              messageUserIds = messages.map((e) => e.id).toList();
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return messages[index].firstMessage ==
                          FirebaseAuth.instance.currentUser!.uid
                      ? GhostChatListTile(
                          messageDetails: messages[index],
                          ontapTile: () => Get.to(
                            () => GhostChatScreen2(
                              firstMessagebyMe: messages[index].firstMessage ==
                                  FirebaseAuth.instance.currentUser!.uid,
                              appUserId: messages[index].id,
                              creatorDetails: messages[index].creatorDetails,
                            ),
                          ),
                        )
                      : GhostChatUserListTile(
                          messageDetails: messages[index],
                          ontapTile: () => Get.to(
                            () => GhostChatScreen2(
                              firstMessagebyMe: messages[index].firstMessage ==
                                  FirebaseAuth.instance.currentUser!.uid,
                              appUserId: messages[index].id,
                              creatorDetails: messages[index].creatorDetails,
                            ),
                          ),
                        );
                },
              );
            }
          },
        ),
        const Divider(),
        Consumer<List<UserModel>?>(
          builder: (context, users, b) {
            if (users == null) {
              return Container();
            } else {
              var currentUser = users
                  .where((element) =>
                      element.id == FirebaseAuth.instance.currentUser!.uid)
                  .first;
              var followingAndFollowersList = users
                  .where((element) =>
                      currentUser.followersIds.contains(element.id) ||
                      currentUser.followingsIds.contains(element.id))
                  .toList();

              List<UserModel> filterList = followingAndFollowersList
                  .where((element) => !messageUserIds.contains(element.id))
                  .toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filterList.length,
                itemBuilder: (context, index) {
                  return ChatUserListTileForNoChat(
                    userModel: filterList[index],
                    ontapTile: () => Get.to(
                      () => GhostChatScreen2(
                        firstMessagebyMe: true,
                        appUserId: filterList[index].id,
                        creatorDetails: CreatorDetails(
                          name: filterList[index].username,
                          imageUrl: filterList[index].imageStr,
                          isVerified: filterList[index].isVerified,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
