import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_controller.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_inbox_screen.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// import 'package:intl/intl.dart';s
import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';
import '../../dashboard/dashboard.dart';
import '../../home/HomeScreen/home_screen_controller.dart';
import '../../profile/ProfileScreen/profile_screen_controller.dart';
import '../Chat one-to-one/chat_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

String convertDateIntoTime(String date) {
  var time = timeago.format(
    DateTime.parse(
      date,
    ),
  );

  return time;
}

class ChatListScreen extends StatelessWidget {
  ChatListScreen({Key? key}) : super(key: key);
  final ChatListController chatListController = Get.put(ChatListController());
  final homeScreenController = Get.put(HomeScreenController());
  ProfileScreenController profileScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppbar(
          title: 'Messages',
          elevation: 0,
          leading: ghostModeBtn(),
          actions: homeScreenController
                  .profileScreenController.isGhostModeOn.value
              ? [
                  IconButton(
                      onPressed: () {
                        Get.to(
                          () => Scaffold(
                              appBar: AppBar(
                                title: const Text("Ghost Chat"),
                                leading: const BackButton(color: Colors.black),
                                backgroundColor: Colors.white,
                              ),
                              body: const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: MessageList(),
                              )),
                        );
                      },
                      icon: Image.asset(imgAddPost))
                ]
              : null,
        ),
        body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  onTap: (v) {},
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey.shade500,
                  tabs: [
                    profileScreenController.isGhostModeOn.value
                        ? Tab(
                            child: Text("Ghost Messages",style: TextStyle(
                                color: colorPrimaryA05,
                                fontSize: 12),),
                          )
                        : Tab(child: Text("Messages")),
                    profileScreenController.isGhostModeOn.value
                        ? Tab(
                            child: Text("Messages"),
                          )
                        : Tab(child: Text("Ghost Messages")),
                  ],
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        profileScreenController.isGhostModeOn.value
                            ? const MessageList1()
                            : const MessageList(),
                        profileScreenController.isGhostModeOn.value
                            ? const MessageList()
                            : const MessageList1(),
                      ]),
                )
              ],
            )));
  }
}

String generateRandomString(int lengthOfString) {
  final random = Random();
  const allChars =
      'AaBbCcDdlMmNnOoPpQqRrS234567890sTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL';
  // below statement will generate a random string of length using the characters
  // and length provided to it
  final randomString = List.generate(
          lengthOfString, (index) => allChars[random.nextInt(allChars.length)])
      .join();
  return randomString; // return the generated string
}

class MessageList1 extends StatefulWidget {
  const MessageList1({Key? key}) : super(key: key);

  @override
  State<MessageList1> createState() => _MessageList1State();
}

class _MessageList1State extends State<MessageList1>
    with AutomaticKeepAliveClientMixin {
  final ChatListController chatListController = Get.put(ChatListController());
  final homeScreenController = Get.put(HomeScreenController());
  ProfileScreenController profileScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: searchTextField(
            context: context,
            controller: chatListController.searchController,
            onChange: (value) {
              chatListController.searchQuery.value = value;
            },
          ),
        ),
        heightBox(10.h),
        profileScreenController.isGhostModeOn.value
            ? Expanded(
                child: Obx(
                  () => ChatListWidget(
                    query: chatListController.searchQuery.isEmpty
                        ? chatListController.chatListQuery
                        : chatListController.searchListQuery,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///////////////////////////////////////////////////////////////////////
class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList>
    with AutomaticKeepAliveClientMixin {
  final ChatListController chatListController = Get.put(ChatListController());
  final homeScreenController = Get.put(HomeScreenController());
  ProfileScreenController profileScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: searchTextField(
            context: context,
            controller: chatListController.searchController,
            onChange: (value) {
              chatListController.searchQuery.value = value;
            },
          ),
        ),
        heightBox(10.h),
        profileScreenController.isGhostModeOn.value
            ? const SizedBox()
            : Expanded(
                child: Obx(
                  () => ChatListWidget(
                    query: chatListController.searchQuery.isEmpty
                        ? chatListController.chatListQuery
                        : chatListController.searchListQuery,
                  ),
                ),
              )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
////////////////////////////////////////////////////////////////////////////
// class ChatListWidget extends StatefulWidget {
//   const ChatListWidget({Key? key}) : super(key: key);
//   //   final Query<Map<String, dynamic>> query;

//   @override
//   State<ChatListWidget> createState() => _ChatListWidgetState();
// }

// class _ChatListWidgetState extends State<ChatListWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({
    Key? key,
    required this.query,
  }) : super(key: key);

  final Query<Map<String, dynamic>> query;

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  final homeScreenController = Get.put(HomeScreenController());
  ProfileScreenController profileScreenController = Get.find();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, doc) {
            if (doc.hasData && doc.data != null) {
              List followingIds = doc.data!.data()!['followingsIds'];
              List followerIds = doc.data!.data()!['followersIds'];
              List userWhoCanMessage = followingIds + followerIds;

              print(
                  "============== <<<<<<<<<=========>>>>>>>>> user with conversation $userWhoCanMessage");
              List yes = [];
              yes = List.generate(userWhoCanMessage.length, (i) async {
                var ref = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(userWhoCanMessage[i])
                    .collection("messageList")
                    .get();

                return userWhoCanMessage[i];
              });
              print(yes);
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: userWhoCanMessage.isNotEmpty
                    ? FirebaseFirestore.instance
                        .collection("users")
                        .where("id", whereIn: userWhoCanMessage)
                        // .orderBy("createdAt", descending: true)
                        .snapshots()
                    : null,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    print(
                        "========================= ======== ======= $userWhoCanMessage");
                    if (userWhoCanMessage.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        padding: const EdgeInsets.only(bottom: 85),
                        itemBuilder: (context, index) {
                          final UserModel userMmessage = UserModel.fromMap(
                              snapshot.data!.docs[index].data());
                          final CreatorDetails creatorDetails =
                              CreatorDetails.fromMap(
                                  snapshot.data!.docs[index].data());

                          return SizedBox(
                            height: 70,
                            child: ListTile(
                              onTap: () {
                                Get.to(
                                  () => ChatScreen(
                                    appUserId: userMmessage.id,
                                    creatorDetails: creatorDetails,
                                  ),
                                );
                              },
                              title: Row(
                                children: [
                                  profileScreenController.isGhostModeOn.value
                                      ? Text(
                                          "Ghost---",
                                          style: TextStyle(
                                              color: colorPrimaryA05,
                                              fontSize: 12),
                                        )
                                      : SizedBox(),
                                  profileScreenController.isGhostModeOn.value
                                      ? Text(
                                          generateRandomString(7),
                                        )
                                      : Text(userMmessage.name),
                                ],
                              ),
                              subtitle: StreamBuilder<DocumentSnapshot<Map>>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("messageList")
                                    .doc(userMmessage.id)
                                    .snapshots(),
                                builder: (context, d) {
                                  if (d.hasData && d.data!.exists) {
                                    print("hello");
                                    print(d.data!.data()!['lastMessage']);
                                    var data = d.data!.data()!['lastMessage'];
                                    return Text(
                                      data!.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  } else {
                                    return Text(
                                      'Start a conversation with ${userMmessage.name}',
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }
                                },
                              ),
                              leading: CircleAvatar(
                                backgroundImage: userMmessage.imageStr.isEmpty
                                    ? null
                                    : CachedNetworkImageProvider(
                                        userMmessage.imageStr,
                                      ),
                                child: userMmessage.imageStr.isEmpty
                                    ? const Icon(
                                        Icons.question_mark,
                                      )
                                    : null,
                              ),
                              trailing: StreamBuilder<DocumentSnapshot<Map>>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("messageList")
                                    .doc(userMmessage.id)
                                    .snapshots(),
                                builder: (context, d) {
                                  if (d.hasData && d.data!.exists) {
                                    print("hello");
                                    print(d.data!.data()!['createdAt']);
                                    var data = d.data!.data()!;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(convertDateIntoTime(
                                            data['createdAt'].toString())),
                                        data['unreadMessageCount'].toString() ==
                                                "0"
                                            ? const Text("")
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: const BoxDecoration(
                                                    color: Colors.teal,
                                                    shape: BoxShape.circle),
                                                child: Text(
                                                  data['unreadMessageCount']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                      ],
                                    );
                                  } else {
                                    return const Icon(Icons.navigate_next);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "Please start follow people to start conversation with them",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Please start follow people to start conversation with them",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        Visibility(
          visible: isLoading,
          child: Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}
