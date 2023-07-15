import 'dart:math';

import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_screen.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_user_list_tile.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../models/ghost_message_details.dart';
import '../../../resources/color_resources.dart';

import 'package:intl/intl.dart';

String convertDateIntoTime(String date) {
  var time = DateFormat('MMMM d, h:mm a').format(DateTime.parse(date));
  return time;
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: primaryAppbar(
        title: 'Messages',
        elevation: 0,
        // leading: ghostModeBtn(),
        // actions: [IconButton(onPressed: () {}, icon: Image.asset(imgAddPost))],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              onTap: (v) {},
              labelColor: colorPrimaryA05,
              unselectedLabelColor: colorAA3,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              indicatorColor: Colors.yellow,
              indicatorPadding:
                  const EdgeInsets.symmetric(horizontal: 75, vertical: 5),
              tabs: const [
                Tab(
                  text: "Friends",
                ),
                Tab(
                  text: "Ghosts",
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  MessageList(),
                  MessageListGhost(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
                  return GhostChatUserListTile(
                      messageDetails: messages[index], ontapTile: () {});
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
                    ontapTile: () {},
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

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
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
        const Expanded(child: FriendChatList()),
      ],
    );
  }
}

class FriendChatList extends StatefulWidget {
  const FriendChatList({Key? key}) : super(key: key);

  @override
  State<FriendChatList> createState() => _FriendChatListState();
}

class _FriendChatListState extends State<FriendChatList> {
  @override
  Widget build(BuildContext context) {
    List<String> messageUserIds = [];
    return ListView(
      children: [
        Consumer<List<MessageDetails>?>(
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
                  return ChatUserListTile(
                    messageDetails: messages[index],
                    ontapTile: () => Get.to(
                      () => ChatScreen(
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
                      () => ChatScreen(
                        appUserId: filterList[index].id,
                        creatorDetails: CreatorDetails(
                          name: filterList[index].name,
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
