import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_screen.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_user_list_tile.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/shared/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../screens/chat/ChatList/chat_list_controller.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

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
  const FriendChatList({super.key});

  @override
  State<FriendChatList> createState() => _FriendChatListState();
}

class _FriendChatListState extends State<FriendChatList> {
  @override
  Widget build(BuildContext context) {
    final chatQuery = Provider.of<ChatListController>(context);
    // List<String> messageUserIds = [];
    final currentUser = context.watch<UserModel?>();
    return currentUser == null
        ? centerLoader()
        : ListView(
            children: [
              StreamProvider.value(
                value: DataProvider().chatListUsers(),
                initialData: null,
                catchError: (context, error) => null,
                child: Consumer<List<MessageDetails>?>(
                  builder: (context, messages, b) {
                    if (messages == null) {
                      return const ChatShimmerList();
                    } else {
                      // messageUserIds = messages.map((e) => e.id).toList();

                      if (chatQuery.searchController.text.isEmpty ||
                          chatQuery.searchController.text == '') {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return ChatUserListTile(
                              personId: messages[index].id,
                              messageDetails: messages[index],
                              ontapTile: () => Get.to(
                                () => ChatScreen(
                                  appUserId: messages[index].id,
                                ),
                              ),
                            );
                          },
                        );
                      }
                      var filterList = messages
                          .where((element) => element.creatorDetails.name
                              .toLowerCase()
                              .contains(chatQuery.searchController.text
                                  .toLowerCase()))
                          .toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filterList.length,
                        itemBuilder: (context, index) {
                          return ChatUserListTile(
                            personId: filterList[index].id,
                            messageDetails: filterList[index],
                            ontapTile: () => Get.to(
                              () => ChatScreen(
                                appUserId: filterList[index].id,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Divider(
                indent: 20.w,
                endIndent: 20.w,
                color: color221.withOpacity(0.1),
              ),
              StreamProvider.value(
                value: DataProvider().chatListUsers(),
                initialData: null,
                catchError: (context, error) => null,
                child: Consumer<List<MessageDetails>?>(
                  builder: (context, messages, b) {
                    if (messages == null) {
                      return const ChatShimmerList();
                    } else {
                      // var msgIds = messages.map((e) => e.id).toList();
                      return StreamProvider.value(
                        value: DataProvider().nonChatUsers(
                          currentUser.followersIds + currentUser.followingsIds,
                          messages.map((e) => e.id).toSet(),
                        ),
                        initialData: null,
                        catchError: (context, error) => null,
                        child: Consumer<List<UserModel>?>(
                          builder: (context, users, b) {
                            if (users == null) {
                              return Container();
                            } else {
                              if (chatQuery.searchController.text.isEmpty) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: users.length,
                                  padding: const EdgeInsets.only(bottom: 70),
                                  itemBuilder: (context, index) {
                                    return ChatUserListTileForNoChat(
                                      userModel: users[index],
                                      ontapTile: () => Get.to(
                                        () => ChatScreen(
                                          appUserId: users[index].id,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              var searchList = users
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(chatQuery.searchController.text
                                          .toLowerCase()))
                                  .toList();
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: searchList.length,
                                padding: const EdgeInsets.only(bottom: 70),
                                itemBuilder: (context, index) {
                                  return ChatUserListTileForNoChat(
                                    userModel: searchList[index],
                                    ontapTile: () => Get.to(
                                      () => ChatScreen(
                                        appUserId: searchList[index].id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
  }
}
