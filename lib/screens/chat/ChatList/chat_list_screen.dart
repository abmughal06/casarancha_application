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
import 'package:intl/intl.dart';
import '../../../resources/image_resources.dart';
import '../../dashboard/dashboard.dart';
import '../../home/HomeScreen/home_screen_controller.dart';
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
                  tabs: const [
                    Tab(child: Text("Messages")),
                    Tab(
                      child: Text("Ghost Messages"),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                const Expanded(
                  child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        MessageList(),
                        GhostModeInbox(),
                      ]),
                )
              ],
            )));
  }
}

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList>
    with AutomaticKeepAliveClientMixin {
  final ChatListController chatListController = Get.put(ChatListController());
  final homeScreenController = Get.put(HomeScreenController());
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
        Expanded(
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
              if (doc.hasData) {
                List followingIds = doc.data!.data()!['followingsIds'];
                List followerIds = doc.data!.data()!['followersIds'];
                List userWhoCanMessage = followingIds + followerIds;

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: userWhoCanMessage.isNotEmpty
                        ? FirebaseFirestore.instance
                            .collection("users")
                            .where("id", whereIn: userWhoCanMessage)
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection("users")
                            .snapshots(),
                    builder: (context, snapshot) {
                      print(
                          "========================= ======== ======= $userWhoCanMessage");
                      if (userWhoCanMessage.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
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
                                title: Text(userMmessage.name),
                                subtitle: StreamBuilder<DocumentSnapshot<Map>>(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
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
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
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
                                          data['unreadMessageCount']
                                                      .toString() ==
                                                  "0"
                                              ? const Text("")
                                              : Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.teal,
                                                          shape:
                                                              BoxShape.circle),
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
                    });
              } else {
                return const CircularProgressIndicator();
              }
            }),
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
  // return
              //  messageDetails.id != FirebaseAuth.instance.currentUser?.uid
              // ? Column(
              //     children: [
              //       Obx(() {
              // bool isInGhostMode = homeScreenController
              //     .profileScreenController.isGhostModeOn.value;
              // return isInGhostMode
              //     ? ListTile(
              //         onTap: () async {
              //           try {
              //             setState(() {
              //               isLoading = true;
              //             });

              //             await GhostChatHelper.shared
              //                 .ghostConversationColletion(FirebaseAuth
              //                         .instance.currentUser?.uid ??
              //                     "")
              //                 .where("receiverId",
              //                     isEqualTo: messageDetails.id)
              //                 .get()
              //                 .then((value) {
              //               if (value.docs.isNotEmpty) {
              //                 Get.to(
              //                   () => GhostChatScreen(
              //                     receiverUserId: messageDetails.id,
              //                     chatId:
              //                         GhostConversationModel.fromJson(
              //                                 value.docs.first.data())
              //                             .chatId,
              //                   ),
              //                 );
              //               } else {
              //                 Get.to(
              //                   () => GhostChatScreen(
              //                     receiverUserId:
              //                         "${messageDetails.id}",
              //                   ),
              //                 );
              //               }
              //             });
              //           } catch (e) {
              //             print(e);
              //           } finally {
              //             setState(() {
              //               isLoading = false;
              //             });
              //           }
              //         },
              //         title: Text(messageDetails.name),
              //         leading: CircleAvatar(
              //           backgroundImage:
              //               messageDetails.imageStr.isEmpty
              //                   ? null
              //                   : CachedNetworkImageProvider(
              //                       messageDetails.imageStr,
              //                     ),
              //           child: messageDetails.imageStr.isEmpty
              //               ? const Icon(
              //                   Icons.question_mark,
              //                 )
              //               : null,
              //         ),
              //       )
              // :

              // ListTile(
              //     onTap: () {
              //       Get.to(
              //         () => ChatScreen(
              //           appUserId: messageDetails.id,
              //           creatorDetails:
              //               chatMessageDetails.creatorDetails,
              //         ),
              //       );
              //     },
              //     title: Text(
              //         chatMessageDetails.creatorDetails.name),
              //     subtitle:
              //         Text(chatMessageDetails.lastMessage),
              //     leading: CircleAvatar(
              //       backgroundImage: chatMessageDetails
              //               .creatorDetails.imageUrl.isEmpty
              //           ? null
              //           : CachedNetworkImageProvider(
              //               chatMessageDetails
              //                   .creatorDetails.imageUrl,
              //             ),
              //       child: chatMessageDetails
              //               .creatorDetails.imageUrl.isEmpty
              //           ? const Icon(
              //               Icons.question_mark,
              //             )
              //           : null,
              //     ),
              //     trailing: SizedBox(
              //       width: 50,
              //       child: Column(
              //         crossAxisAlignment:
              //             CrossAxisAlignment.center,
              //         children: [
              //           // TextWidget(
              //           //   text:
              //           //       '${lastmessageDate.hour}:${lastmessageDate.minute}',
              //           //   color: color887,
              //           //   fontSize: 12.sp,
              //           // ),
              //           heightBox(3.h),
              //           Container(
              //             padding: const EdgeInsets.all(1),
              //             decoration: BoxDecoration(
              //               color: color746,
              //               borderRadius:
              //                   BorderRadius.circular(20.r),
              //             ),
              //             constraints: BoxConstraints(
              //               minWidth: 20.w,
              //               minHeight: 20.h,
              //             ),
              //             child: Center(
              //               child: TextWidget(
              //                 text: chatMessageDetails
              //                     .unreadMessageCount
              //                     .toString(),
              //                 color: colorWhite,
              //                 fontSize: 12.sp,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   );
        //               const Divider(
        //                 height: 0,
        //                 endIndent: 30,
        //                 indent: 30,
        //               )
        //             ],
        //           )
        //         : Container();
        //   },
        // ),