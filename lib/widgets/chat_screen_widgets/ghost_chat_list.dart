import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/ghost_chat_screen.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_user_list_tile.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../models/ghost_message_details.dart';
import '../../resources/color_resources.dart';
import '../../screens/chat/ChatList/chat_list_controller.dart';

class MessageListGhost extends StatefulWidget {
  const MessageListGhost({super.key});

  @override
  State<MessageListGhost> createState() => _MessageListGhostState();
}

class _MessageListGhostState extends State<MessageListGhost> {
  @override
  Widget build(BuildContext context) {
    final chatQuery = Provider.of<ChatListController>(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: searchTextField(
            context: context,
            controller: chatQuery.ghostSearchController,
            onChange: (value) {
              chatQuery.searchText(value);
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
  const GhostChatList({super.key});

  @override
  Widget build(BuildContext context) {
    // List<String> messageUserIds = [];
    final chatQuery = Provider.of<ChatListController>(context);
    final currentUser = context.watch<UserModel?>();

    return currentUser == null
        ? centerLoader()
        : ListView(
            children: [
              StreamProvider.value(
                value: DataProvider().ghostChatListUsers(),
                initialData: null,
                catchError: (context, error) => null,
                child: Consumer<List<GhostMessageDetails>?>(
                  builder: (context, messages, b) {
                    if (messages == null) {
                      return Container();
                    } else {
                      // print(messages.length);

                      // messageUserIds = messages.map((e) => e.id).toList();
                      // print(messageUserIds);
                      if (chatQuery.ghostSearchController.text.isEmpty ||
                          chatQuery.ghostSearchController.text == '') {
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
                                        ghostMessageDetails: messages[index],
                                        firstMessagebyMe:
                                            messages[index].firstMessage ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                        appUserId: messages[index]
                                                    .id
                                                    .split('_')
                                                    .last ==
                                                currentUserUID
                                            ? messages[index]
                                                .id
                                                .split('_')
                                                .first
                                            : messages[index]
                                                .id
                                                .split('_')
                                                .last,
                                        creatorDetails:
                                            messages[index].creatorDetails,
                                      ),
                                    ),
                                  )
                                : GhostChatUserListTile(
                                    messageDetails: messages[index],
                                    ontapTile: () => Get.to(
                                      () => GhostChatScreen2(
                                        ghostMessageDetails: messages[index],
                                        firstMessagebyMe:
                                            messages[index].firstMessage ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                        appUserId: messages[index].id,
                                        creatorDetails:
                                            messages[index].creatorDetails,
                                      ),
                                    ),
                                  );
                          },
                        );
                      }

                      var filterList = messages
                          .where((element) => element.creatorDetails.name
                              .toLowerCase()
                              .contains(chatQuery.ghostSearchController.text
                                  .toLowerCase()))
                          .toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filterList.length,
                        itemBuilder: (context, index) {
                          return filterList[index].firstMessage ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? GhostChatListTile(
                                  messageDetails: filterList[index],
                                  ontapTile: () => Get.to(
                                    () => GhostChatScreen2(
                                      ghostMessageDetails: filterList[index],
                                      firstMessagebyMe:
                                          filterList[index].firstMessage ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                      appUserId: filterList[index].id,
                                      creatorDetails:
                                          filterList[index].creatorDetails,
                                    ),
                                  ),
                                )
                              : GhostChatUserListTile(
                                  messageDetails: filterList[index],
                                  ontapTile: () => Get.to(
                                    () => GhostChatScreen2(
                                      ghostMessageDetails: filterList[index],
                                      firstMessagebyMe:
                                          filterList[index].firstMessage ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                      appUserId: filterList[index].id,
                                      creatorDetails:
                                          filterList[index].creatorDetails,
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
                value: DataProvider().ghostChatListUsers(),
                initialData: null,
                catchError: (context, error) => null,
                child: Consumer<List<GhostMessageDetails>?>(
                  builder: (context, messages, b) {
                    if (messages == null) {
                      return Container();
                    } else {
                      return StreamProvider.value(
                        value: DataProvider().nonChatUsers(
                            currentUser.followersIds +
                                currentUser.followingsIds,
                            messages
                                .map((e) =>
                                    e.id.split('_').last == currentUserUID
                                        ? e.id.split('_').first
                                        : e.id.split('_').last)
                                .toSet()),
                        initialData: null,
                        catchError: (context, error) => null,
                        child: Consumer<List<UserModel>?>(
                          builder: (context, users, b) {
                            if (users == null) {
                              return Container();
                            } else {
                              if (chatQuery
                                      .ghostSearchController.text.isEmpty ||
                                  chatQuery.ghostSearchController.text == '') {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: users.length,
                                  padding: const EdgeInsets.only(bottom: 70),
                                  itemBuilder: (context, index) {
                                    return ChatUserListTileForNoChat(
                                      userModel: users[index],
                                      ontapTile: () => Get.to(
                                        () => GhostChatScreen2(
                                          firstMessagebyMe: true,
                                          appUserId: users[index].id,
                                          creatorDetails: CreatorDetails(
                                            name: users[index].username,
                                            imageUrl: users[index].imageStr,
                                            isVerified: users[index].isVerified,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }

                              var searchList = users
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(chatQuery
                                          .ghostSearchController.text
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
                                      () => GhostChatScreen2(
                                        firstMessagebyMe: true,
                                        appUserId: searchList[index].id,
                                        creatorDetails: CreatorDetails(
                                          name: searchList[index].username,
                                          imageUrl: searchList[index].imageStr,
                                          isVerified:
                                              searchList[index].isVerified,
                                        ),
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
              )
            ],
          );
  }
}
