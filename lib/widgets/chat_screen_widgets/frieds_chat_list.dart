import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_screen.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_user_list_tile.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../screens/chat/ChatList/chat_list_controller.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    final chatQuery = Provider.of<ChatListController>(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: searchTextField(
            context: context,
            controller: chatQuery.searchController,
            onChange: (value) {
              chatQuery.searchText(value);
            },
          ),
        ),
        heightBox(10.h),
        const Expanded(
          child: FriendChatList(),
        ),
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
    final chatQuery = Provider.of<ChatListController>(context);
    final users = context.watch<List<UserModel>?>();

    List<String> messageUserIds = [];
    return ListView(
      children: [
        Consumer<List<MessageDetails>?>(
          builder: (context, messages1, b) {
            if (messages1 == null || users == null) {
              return const CircularProgressIndicator.adaptive();
            } else {
              List<MessageDetails> messages = [];
              List<UserModel> messagePerson = [];
              for (var m in messages1) {
                for (var u in users) {
                  if (m.id == u.id) {
                    messages.add(m);
                    messagePerson.add(u);
                  }
                }
              }
              messageUserIds = messages.map((e) => e.id).toList();

              if (chatQuery.searchController.text.isEmpty ||
                  chatQuery.searchController.text == '') {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ChatUserListTile(
                      personDetail: messagePerson[index],
                      messageDetails: messages[index],
                      ontapTile: () => Get.to(
                        () => ChatScreen(
                          appUserId: messages[index].id,
                          creatorDetails: CreatorDetails(
                            name: messagePerson[index].name,
                            imageUrl: messagePerson[index].imageStr,
                            isVerified: messagePerson[index].isVerified,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              var filterList = messages
                  .where((element) => element.creatorDetails.name
                      .toLowerCase()
                      .contains(chatQuery.searchController.text.toLowerCase()))
                  .toList();
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filterList.length,
                itemBuilder: (context, index) {
                  return ChatUserListTile(
                    personDetail: messagePerson[index],
                    messageDetails: filterList[index],
                    ontapTile: () => Get.to(
                      () => ChatScreen(
                        appUserId: filterList[index].id,
                        creatorDetails: CreatorDetails(
                          name: messagePerson[index].name,
                          imageUrl: messagePerson[index].imageStr,
                          isVerified: messagePerson[index].isVerified,
                        ),
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

              if (chatQuery.searchController.text.isEmpty) {
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
              var searchList = filterList
                  .where((element) => element.name
                      .toLowerCase()
                      .contains(chatQuery.searchController.text.toLowerCase()))
                  .toList();
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchList.length,
                itemBuilder: (context, index) {
                  return ChatUserListTileForNoChat(
                    userModel: searchList[index],
                    ontapTile: () => Get.to(
                      () => ChatScreen(
                        appUserId: searchList[index].id,
                        creatorDetails: CreatorDetails(
                          name: searchList[index].name,
                          imageUrl: searchList[index].imageStr,
                          isVerified: searchList[index].isVerified,
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

class DataCall extends StatelessWidget {
  const DataCall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
