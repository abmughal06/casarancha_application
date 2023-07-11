import 'dart:developer' as dev;
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/ghost_chat_screen.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_controller.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_chat_screen.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// import 'package:intl/intl.dart';s
import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/text_widget.dart';
import '../../dashboard/dashboard.dart';
import '../../home/HomeScreen/home_screen_controller.dart';
import '../../profile/ProfileScreen/profile_screen_controller.dart';
import '../Chat one-to-one/chat_screen.dart';

import 'package:intl/intl.dart';

String convertDateIntoTime(String date) {
  var time = DateFormat('MMMM d, h:mm a').format(DateTime.parse(date));
  return time;
}

class ChatListScreen extends StatelessWidget {
  ChatListScreen({Key? key}) : super(key: key);
  // final ChatListController chatListController = Get.put(ChatListController());
  // final homeScreenController = Get.put(HomeScreenController());
  // ProfileScreenController profileScreenController = Get.find();
  // TabController tabController=TabController(length: length, vsync: vsync)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: primaryAppbar(
        title: 'Messages',
        elevation: 0,
        // leading: ghostModeBtn(),
        // actions: homeScreenController
        //         .profileScreenController.isGhostModeOn.value
        //     ? [
        //         IconButton(
        //             onPressed: () {
        //               Get.to(
        //                 () => Scaffold(
        //                     appBar: AppBar(
        //                       title: const Text("Ghost Chat"),
        //                       leading: const BackButton(color: Colors.black),
        //                       backgroundColor: Colors.white,
        //                     ),
        //                     body: const Padding(
        //                       padding: EdgeInsets.only(top: 10),
        //                       child: MessageList(),
        //                     )),
        //               );
        //             },
        //             icon: Image.asset(imgAddPost))
        //       ]
        //     : null,
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
              tabs: [
                const Tab(
                  text: "Friends",
                ),
                const Tab(
                  text: "Ghosts",
                ),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Container(),
                    Container(),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

// String generateRandomString(int lengthOfString) {
//   final random = Random();
//   const allChars =
//       'AaBbCcDdlMmNnOoPpQqRrS234567890sTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL';
//   // below statement will generate a random string of length using the characters
//   // and length provided to it
//   final randomString = List.generate(
//           lengthOfString, (index) => allChars[random.nextInt(allChars.length)])
//       .join();
//   return randomString; // return the generated string
// }

// class MessageListGhost extends StatefulWidget {
//   const MessageListGhost({Key? key}) : super(key: key);

//   @override
//   State<MessageListGhost> createState() => _MessageListGhostState();
// }

// class _MessageListGhostState extends State<MessageListGhost>
//     with AutomaticKeepAliveClientMixin {
//   // final ChatListController chatListController = Get.put(ChatListController());
//   // final homeScreenController = Get.put(HomeScreenController());
//   // ProfileScreenController profileScreenController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: searchTextField(
//             context: context,
//             controller: TextEditingController(),
//             onChange: (value) {
//               // chatListController.searchQuery.value = value;
//             },
//           ),
//         ),
//         heightBox(10.h),
//         Expanded(
//           child: ChatListWidgetGhost(
//             query: [],
//           ),
//         )
//       ],
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

// ///////////////////////////////////////////////////////////////////////
// class MessageList extends StatefulWidget {
//   const MessageList({Key? key}) : super(key: key);

//   @override
//   State<MessageList> createState() => _MessageListState();
// }

// class _MessageListState extends State<MessageList>
//     with AutomaticKeepAliveClientMixin {
//   // final ChatListController chatListController = Get.put(ChatListController());
//   // final homeScreenController = Get.put(HomeScreenController());
//   // ProfileScreenController profileScreenController = Get.find();
//   var searchUser = chatUser + noChatUser;

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: searchTextField(
//             context: context,
//             controller: TextEditingController(),
//             onChange: (value) {
//               // chatListController.searchQuery.value = value;
//             },
//           ),
//         ),
//         heightBox(10.h),
//         Expanded(
//           child: ChatListWidget(
//             query: [],
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

// List<CreatorDetails> chatUser = [];
// List<CreatorDetails> noChatUser = [];

// class ChatListWidget extends StatefulWidget {
//   const ChatListWidget({
//     Key? key,
//     required this.query,
//   }) : super(key: key);

//   final List<String> query;

//   @override
//   State<ChatListWidget> createState() => _ChatListWidgetState();
// }

// class _ChatListWidgetState extends State<ChatListWidget> {
//   // final homeScreenController = Get.put(HomeScreenController());
//   // final ChatListController chatListController = Get.find();
//   // ProfileScreenController profileScreenController = Get.find();
//   bool isLoading = false;
//   String val1 = "";

//   @override
//   void initState() {
//     // chatListController.encodeName = "";
//     super.initState();
//   }

//   bool compareStrings(String string1, String string2) {
//     int matchCount = 0;

//     // Loop through each character of the first string
//     for (int i = 0; i < string1.length; i++) {
//       // Loop through each character of the second string
//       for (int j = 0; j < string2.length; j++) {
//         // If the characters match, increment the match count
//         if (string1[i] == string2[j]) {
//           matchCount++;
//         }
//       }
//     }
//     // Return true if two or more characters match
//     return matchCount >= 3;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                 stream: FirebaseFirestore.instance
//                     .collection("users")
//                     .doc(FirebaseAuth.instance.currentUser!.uid)
//                     .collection("messageList")
//                     .orderBy("createdAt", descending: true)
//                     .snapshots(),
//                 builder: (context, doc) {
//                   print(
//                       "------------------------------------- >>>>>>>>> ${doc.data}");
//                   if (doc.hasData && doc.data != null) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: doc.data!.docs.length,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         final CreatorDetails creatorDetails =
//                             CreatorDetails.fromMap(
//                                 doc.data!.docs[index].data()['creatorDetails']);
//                         final appUserId = doc.data!.docs[index].data()['id'];
//                         final data = doc.data!.docs[index].data();
//                         val1 = generateRandomString(7);
//                         print(creatorDetails);
//                         chatUser.add(creatorDetails);
//                         // if (chatListController
//                         //     .searchController.text.isNotEmpty) {
//                         //   if (compareStrings(creatorDetails.name,
//                         //       chatListController.searchController.text)) {
//                             return SizedBox(
//                               child: ListTile(
//                                 onTap: () {
//                                   Get.to(
//                                     () => ChatScreen(
//                                       appUserId: appUserId,
//                                       creatorDetails: creatorDetails,
//                                       profileScreenController:
//                                           profileScreenController,
//                                       val: val1,
//                                     ),
//                                   );
//                                 },
//                                 title: Row(
//                                   children: [
//                                     TextWidget(
//                                       text: creatorDetails.name,
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: const Color(0xff222939),
//                                     ),
//                                     widthBox(5.w),
//                                     Visibility(
//                                         visible: creatorDetails.isVerified,
//                                         child: SvgPicture.asset(icVerifyBadge))
//                                   ],
//                                 ),
//                                 subtitle: TextWidget(
//                                   text: data['lastMessage'].toString(),
//                                   textOverflow: TextOverflow.ellipsis,
//                                   fontWeight: data['unreadMessageCount'] == 0
//                                       ? FontWeight.w400
//                                       : FontWeight.w700,
//                                   fontSize: 14.sp,
//                                   color: data['unreadMessageCount'] == 0
//                                       ? const Color(0xff8a8a8a)
//                                       : const Color(0xff000000),
//                                 ),
//                                 leading: CircleAvatar(
//                                   backgroundImage:
//                                       creatorDetails.imageUrl.isEmpty
//                                           ? null
//                                           : CachedNetworkImageProvider(
//                                               creatorDetails.imageUrl,
//                                             ),
//                                   child: creatorDetails.imageUrl.isEmpty
//                                       ? const Icon(
//                                           Icons.question_mark,
//                                         )
//                                       : null,
//                                 ),
//                                 trailing: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     TextWidget(
//                                       text: convertDateIntoTime(
//                                           data['createdAt'].toString()),
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 12.sp,
//                                       color: const Color(0xff878787),
//                                     ),
//                                     SizedBox(height: 5.h),
//                                     data['unreadMessageCount'] == 0
//                                         ? const Icon(Icons.navigate_next)
//                                         : data['unreadMessageCount']
//                                                     .toString() ==
//                                                 "0"
//                                             ? const Text("")
//                                             : Container(
//                                                 padding:
//                                                     const EdgeInsets.all(3),
//                                                 decoration: const BoxDecoration(
//                                                     color: Color(0xff7BC246),
//                                                     shape: BoxShape.circle),
//                                                 child: Text(
//                                                   data['unreadMessageCount']
//                                                       .toString(),
//                                                   style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 12.sp,
//                                                       fontWeight:
//                                                           FontWeight.w400),
//                                                 ),
//                                               ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           // } else {
//                           //   return Container();
//                           // }
//                         // } else {
//                         //   return SizedBox(
//                         //     child: ListTile(
//                         //       onTap: () {
//                         //         Get.to(
//                         //           () => ChatScreen(
//                         //             appUserId: appUserId,
//                         //             creatorDetails: creatorDetails,
//                         //             profileScreenController:
//                         //                 profileScreenController,
//                         //             val: val1,
//                         //           ),
//                         //         );
//                         //       },
//                         //       title: Row(
//                         //         children: [
//                         //           TextWidget(
//                         //             text: creatorDetails.name,
//                         //             fontSize: 14.sp,
//                         //             fontWeight: FontWeight.w500,
//                         //             color: const Color(0xff222939),
//                         //           ),
//                         //           widthBox(5.w),
//                         //           Visibility(
//                         //               visible: creatorDetails.isVerified,
//                         //               child: SvgPicture.asset(icVerifyBadge))
//                         //         ],
//                         //       ),
//                         //       subtitle: TextWidget(
//                         //         text: data['lastMessage'].toString(),
//                         //         textOverflow: TextOverflow.ellipsis,
//                         //         fontWeight: data['unreadMessageCount'] == 0
//                         //             ? FontWeight.w400
//                         //             : FontWeight.w700,
//                         //         fontSize: 14.sp,
//                         //         color: data['unreadMessageCount'] == 0
//                         //             ? const Color(0xff8a8a8a)
//                         //             : const Color(0xff000000),
//                         //       ),
//                         //       leading: CircleAvatar(
//                         //         backgroundImage: creatorDetails.imageUrl.isEmpty
//                         //             ? null
//                         //             : CachedNetworkImageProvider(
//                         //                 creatorDetails.imageUrl,
//                         //               ),
//                         //         child: creatorDetails.imageUrl.isEmpty
//                         //             ? const Icon(
//                         //                 Icons.question_mark,
//                         //               )
//                         //             : null,
//                         //       ),
//                         //       trailing: Column(
//                         //         crossAxisAlignment: CrossAxisAlignment.end,
//                         //         mainAxisAlignment: MainAxisAlignment.center,
//                         //         children: [
//                         //           TextWidget(
//                         //             text: convertDateIntoTime(
//                         //                 data['createdAt'].toString()),
//                         //             fontWeight: FontWeight.w400,
//                         //             fontSize: 12.sp,
//                         //             color: const Color(0xff878787),
//                         //           ),
//                         //           SizedBox(height: 5.h),
//                         //           data['unreadMessageCount'] == 0
//                         //               ? const Icon(Icons.navigate_next)
//                         //               : data['unreadMessageCount'].toString() ==
//                         //                       "0"
//                         //                   ? const Text("")
//                         //                   : Container(
//                         //                       padding: const EdgeInsets.all(3),
//                         //                       decoration: const BoxDecoration(
//                         //                           color: Color(0xff7BC246),
//                         //                           shape: BoxShape.circle),
//                         //                       child: Text(
//                         //                         data['unreadMessageCount']
//                         //                             .toString(),
//                         //                         style: TextStyle(
//                         //                             color: Colors.white,
//                         //                             fontSize: 12.sp,
//                         //                             fontWeight:
//                         //                                 FontWeight.w400),
//                         //                       ),
//                         //                     ),
//                         //         ],
//                         //       ),
//                         //     ),
//                         //   );
//                         // }
//                       },
//                     );
//                   } else if (doc.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator();
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//               const Divider(),
//               StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                 stream: FirebaseFirestore.instance
//                     .collection("users")
//                     .doc(FirebaseAuth.instance.currentUser!.uid)
//                     .snapshots(),
//                 builder: (context, doc) {
//                   if (doc.hasData && doc.data != null) {
//                     var currentUser = UserModel.fromMap(doc.data!.data()!);

//                     List userWhoCanMessage1 =
//                         currentUser.followersIds + currentUser.followingsIds;
//                     var msg = userWhoCanMessage1.toSet();
//                     List userWhoCanMessage = msg.toList();

//                     print(
//                         "============== <<<<<<<<<=========>>>>>>>>> userWhoCanMessage $userWhoCanMessage");
//                     print(
//                         "============== <<<<<<<<<=========>>>>>>>>> userWhoCanMessage1 $userWhoCanMessage1");

//                     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                       stream: userWhoCanMessage.isNotEmpty
//                           ? FirebaseFirestore.instance
//                               .collection("users")
//                               .snapshots()
//                           : null,
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData && snapshot.data != null) {
//                           dev.log(
//                               "========================= ======== ======= ${userWhoCanMessage.length}");
//                           if (userWhoCanMessage.isNotEmpty) {
//                             return ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: snapshot.data!.docs.length,
//                               physics: const NeverScrollableScrollPhysics(),
//                               padding: const EdgeInsets.only(bottom: 85),
//                               itemBuilder: (context, index) {
//                                 if (userWhoCanMessage.contains(
//                                     snapshot.data!.docs[index].data()['id'])) {
//                                   final UserModel userMmessage =
//                                       UserModel.fromMap(
//                                           snapshot.data!.docs[index].data());
//                                   final CreatorDetails creatorDetails =
//                                       CreatorDetails.fromMap(
//                                           snapshot.data!.docs[index].data());
//                                   var val11 = generateRandomString(7);

//                                   return StreamBuilder<DocumentSnapshot<Map>>(
//                                     stream: FirebaseFirestore.instance
//                                         .collection("users")
//                                         .doc(FirebaseAuth
//                                             .instance.currentUser!.uid)
//                                         .collection("messageList")
//                                         .doc(userMmessage.id)
//                                         .snapshots(),
//                                     builder: (context, d) {
//                                       if (d.hasData && d.data!.exists) {
//                                         dev.log("true");
//                                         return Container();
//                                       } else {
//                                         // noChatUser.add(creatorDetails);
//                                         // if (chatListController
//                                         //     .searchController.text.isNotEmpty) {
//                                         //   if (compareStrings(
//                                         //       userMmessage.name,
//                                         //       chatListController
//                                         //           .searchController.text)) {
//                                             return SizedBox(
//                                               height: 70,
//                                               child: ListTile(
//                                                 onTap: () {
//                                                   Get.to(
//                                                     () => ChatScreen(
//                                                       appUserId:
//                                                           userMmessage.id,
//                                                       creatorDetails:
//                                                           creatorDetails,
//                                                       profileScreenController:
//                                                           profileScreenController,
//                                                       val: val11,
//                                                     ),
//                                                   );
//                                                 },
//                                                 title: Row(
//                                                   children: [
//                                                     TextWidget(
//                                                       text: creatorDetails.name,
//                                                       fontSize: 14.sp,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       color: const Color(
//                                                           0xff222939),
//                                                     ),
//                                                     widthBox(5.w),
//                                                     Visibility(
//                                                         visible: creatorDetails
//                                                             .isVerified,
//                                                         child: SvgPicture.asset(
//                                                             icVerifyBadge))
//                                                   ],
//                                                 ),
//                                                 subtitle: TextWidget(
//                                                   text:
//                                                       'Start a conversation with ${profileScreenController.isGhostModeOn.value ? "Ghost" : userMmessage.name}',
//                                                   textOverflow:
//                                                       TextOverflow.ellipsis,
//                                                   fontWeight: FontWeight.w400,
//                                                   fontSize: 14.sp,
//                                                   color:
//                                                       const Color(0xff8a8a8a),
//                                                 ),
//                                                 leading: CircleAvatar(
//                                                   backgroundImage:
//                                                       CachedNetworkImageProvider(
//                                                     userMmessage.imageStr,
//                                                   ),
//                                                   child: const Icon(
//                                                     Icons.question_mark,
//                                                   ),
//                                                 ),
//                                                 trailing: const Icon(
//                                                     Icons.navigate_next),
//                                               ),
//                                             );
//                                           } else {
//                                             return Container();
//                                           }
//                                         } else {
//                                           return SizedBox(
//                                             height: 70,
//                                             child: ListTile(
//                                               onTap: () {
//                                                 Get.to(
//                                                   () => ChatScreen(
//                                                     appUserId: userMmessage.id,
//                                                     creatorDetails:
//                                                         creatorDetails,
//                                                     profileScreenController:
//                                                         profileScreenController,
//                                                     val: val11,
//                                                   ),
//                                                 );
//                                               },
//                                               title: Row(
//                                                 children: [
//                                                   TextWidget(
//                                                     text: creatorDetails.name,
//                                                     fontSize: 14.sp,
//                                                     fontWeight: FontWeight.w500,
//                                                     color:
//                                                         const Color(0xff222939),
//                                                   ),
//                                                   widthBox(5.w),
//                                                   Visibility(
//                                                       visible: creatorDetails
//                                                           .isVerified,
//                                                       child: SvgPicture.asset(
//                                                           icVerifyBadge))
//                                                 ],
//                                               ),
//                                               subtitle: TextWidget(
//                                                 text:
//                                                     'Start a conversation with ${profileScreenController.isGhostModeOn.value ? "Ghost" : userMmessage.name}',
//                                                 textOverflow:
//                                                     TextOverflow.ellipsis,
//                                                 fontWeight: FontWeight.w400,
//                                                 fontSize: 14.sp,
//                                                 color: const Color(0xff8a8a8a),
//                                               ),
//                                               leading: CircleAvatar(
//                                                 backgroundImage:
//                                                     CachedNetworkImageProvider(
//                                                   userMmessage.imageStr,
//                                                 ),
//                                               ),
//                                               trailing: const Icon(
//                                                   Icons.navigate_next),
//                                             ),
//                                           );
//                                         }
//                                       }
//                                     },
//                                   );
//                                 } else {
//                                   return Container();
//                                 }
//                               },
//                             );
//                           } else {
//                             return const Center(
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 40),
//                                 child: Text(
//                                   "Please start follow people to start conversation with them",
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             );
//                           }
//                         } else if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const CircularProgressIndicator();
//                         } else {
//                           return const Center(
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 40),
//                               child: Text(
//                                 "Please start follow people to start conversation with them",
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     );
//                   } else {
//                     return const CircularProgressIndicator();
//                   }
//                 },
//               ),
//               const SizedBox(height: 90)
//             ],
//           ),
//         ),
//         Visibility(
//           visible: isLoading,
//           child: Container(
//             alignment: Alignment.center,
//             child: const CircularProgressIndicator(),
//           ),
//         )
//       ],
//     );
//   }
// }

// class ChatListWidgetGhost extends StatefulWidget {
//   const ChatListWidgetGhost({
//     Key? key,
//     required this.query,
//   }) : super(key: key);

//   final List<String> query;

//   @override
//   State<ChatListWidgetGhost> createState() => _ChatListWidgetGhostState();
// }

// class _ChatListWidgetGhostState extends State<ChatListWidgetGhost> {
//   // final homeScreenController = Get.put(HomeScreenController());
//   // final ChatListController chatListController = Get.find();
//   // ProfileScreenController profileScreenController = Get.find();
//   bool isLoading = false;
//   String val1 = "";

//   @override
//   void initState() {
//     // chatListController.encodeName = "";
//     super.initState();
//   }

//   bool compareStrings(String string1, String string2) {
//     int matchCount = 0;

//     // Loop through each character of the first string
//     for (int i = 0; i < string1.length; i++) {
//       // Loop through each character of the second string
//       for (int j = 0; j < string2.length; j++) {
//         // If the characters match, increment the match count
//         if (string1[i] == string2[j]) {
//           matchCount++;
//         }
//       }
//     }
//     // Return true if two or more characters match
//     return matchCount >= 3;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                 stream: FirebaseFirestore.instance
//                     .collection("users")
//                     .doc(FirebaseAuth.instance.currentUser!.uid)
//                     .collection("ghostMessageList")
//                     .orderBy("createdAt", descending: true)
//                     .snapshots(),
//                 builder: (context, doc) {
//                   print(
//                       "------------------------------------- >>>>>>>>> ${doc.data}");
//                   if (doc.hasData && doc.data != null) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: doc.data!.docs.length,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         final CreatorDetails creatorDetails =
//                             CreatorDetails.fromMap(
//                                 doc.data!.docs[index].data()['creatorDetails']);
//                         final appUserId = doc.data!.docs[index].data()['id'];
//                         final data = doc.data!.docs[index].data();
//                         val1 = generateRandomString(7);
//                         print(creatorDetails);
//                         chatUser.add(creatorDetails);
//                         if (chatListController
//                             .searchController.text.isNotEmpty) {
//                           if (compareStrings(creatorDetails.name,
//                               chatListController.searchController.text)) {
//                             return SizedBox(
//                               child: ListTile(
//                                 onTap: () {
//                                   Get.to(
//                                     () => GhostChatScreen2(
//                                       appUserId: appUserId,
//                                       creatorDetails: creatorDetails,
//                                       profileScreenController:
//                                           profileScreenController,
//                                       val: val1,
//                                     ),
//                                   );
//                                 },
//                                 title: Row(
//                                   children: [
//                                     const Text(
//                                       "Ghost---",
//                                       style: TextStyle(
//                                           color: colorPrimaryA05, fontSize: 12),
//                                     ),
//                                     Text(
//                                       val1,
//                                     ),
//                                   ],
//                                 ),
//                                 subtitle: TextWidget(
//                                   text: data['lastMessage'].toString(),
//                                   textOverflow: TextOverflow.ellipsis,
//                                   fontWeight: data['unreadMessageCount'] == 0
//                                       ? FontWeight.w400
//                                       : FontWeight.w700,
//                                   fontSize: 14.sp,
//                                   color: data['unreadMessageCount'] == 0
//                                       ? const Color(0xff8a8a8a)
//                                       : const Color(0xff000000),
//                                 ),
//                                 leading: CircleAvatar(
//                                   backgroundImage:
//                                       creatorDetails.imageUrl.isEmpty
//                                           ? null
//                                           : CachedNetworkImageProvider(
//                                               creatorDetails.imageUrl,
//                                             ),
//                                   child: creatorDetails.imageUrl.isEmpty
//                                       ? const Icon(
//                                           Icons.question_mark,
//                                         )
//                                       : null,
//                                 ),
//                                 trailing: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     TextWidget(
//                                       text: convertDateIntoTime(
//                                           data['createdAt'].toString()),
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 12.sp,
//                                       color: const Color(0xff878787),
//                                     ),
//                                     SizedBox(height: 5.h),
//                                     data['unreadMessageCount'] == 0
//                                         ? const Icon(Icons.navigate_next)
//                                         : data['unreadMessageCount']
//                                                     .toString() ==
//                                                 "0"
//                                             ? const Text("")
//                                             : Container(
//                                                 padding:
//                                                     const EdgeInsets.all(3),
//                                                 decoration: const BoxDecoration(
//                                                     color: Color(0xff7BC246),
//                                                     shape: BoxShape.circle),
//                                                 child: Text(
//                                                   data['unreadMessageCount']
//                                                       .toString(),
//                                                   style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 12.sp,
//                                                       fontWeight:
//                                                           FontWeight.w400),
//                                                 ),
//                                               ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return Container();
//                           }
//                         } else {
//                           return SizedBox(
//                             child: ListTile(
//                               onTap: () {
//                                 Get.to(
//                                   () => GhostChatScreen2(
//                                     appUserId: appUserId,
//                                     creatorDetails: creatorDetails,
//                                     profileScreenController:
//                                         profileScreenController,
//                                     val: val1,
//                                   ),
//                                 );
//                               },
//                               title: Row(
//                                 children: [
//                                   const Text(
//                                     "Ghost----",
//                                     style: TextStyle(
//                                         color: colorPrimaryA05, fontSize: 12),
//                                   ),
//                                   Text(
//                                     val1,
//                                   ),
//                                 ],
//                               ),
//                               subtitle: TextWidget(
//                                 text: data['lastMessage'].toString(),
//                                 textOverflow: TextOverflow.ellipsis,
//                                 fontWeight: data['unreadMessageCount'] == 0
//                                     ? FontWeight.w400
//                                     : FontWeight.w700,
//                                 fontSize: 14.sp,
//                                 color: data['unreadMessageCount'] == 0
//                                     ? const Color(0xff8a8a8a)
//                                     : const Color(0xff000000),
//                               ),
//                               leading: CircleAvatar(
//                                 backgroundImage: creatorDetails.imageUrl.isEmpty
//                                     ? null
//                                     : CachedNetworkImageProvider(
//                                         creatorDetails.imageUrl,
//                                       ),
//                                 child: creatorDetails.imageUrl.isEmpty
//                                     ? const Icon(
//                                         Icons.question_mark,
//                                       )
//                                     : null,
//                               ),
//                               trailing: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   TextWidget(
//                                     text: convertDateIntoTime(
//                                         data['createdAt'].toString()),
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 12.sp,
//                                     color: const Color(0xff878787),
//                                   ),
//                                   SizedBox(height: 5.h),
//                                   data['unreadMessageCount'] == 0
//                                       ? const Icon(Icons.navigate_next)
//                                       : data['unreadMessageCount'].toString() ==
//                                               "0"
//                                           ? const Text("")
//                                           : Container(
//                                               padding: const EdgeInsets.all(3),
//                                               decoration: const BoxDecoration(
//                                                   color: Color(0xff7BC246),
//                                                   shape: BoxShape.circle),
//                                               child: Text(
//                                                 data['unreadMessageCount']
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 12.sp,
//                                                     fontWeight:
//                                                         FontWeight.w400),
//                                               ),
//                                             ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     );
//                   } else if (doc.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator();
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//               const Divider(),
//               StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                 stream: FirebaseFirestore.instance
//                     .collection("users")
//                     .doc(FirebaseAuth.instance.currentUser!.uid)
//                     .snapshots(),
//                 builder: (context, doc) {
//                   if (doc.hasData && doc.data != null) {
//                     var currentUser = UserModel.fromMap(doc.data!.data()!);
//                     List followingIds = currentUser.followingsIds;
//                     List followerIds = currentUser.followersIds;
//                     List userWhoCanMessage1 = followingIds + followerIds;
//                     var msg = userWhoCanMessage1.toSet();
//                     var userWhoCanMessage = msg.toList();

//                     dev.log(
//                         "============== <<<<<<<<<=========>>>>>>>>> user with conversation $userWhoCanMessage");

//                     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                       stream: userWhoCanMessage.isNotEmpty
//                           ? FirebaseFirestore.instance
//                               .collection("users")
//                               .snapshots()
//                           : null,
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData && snapshot.data != null) {
//                           dev.log(
//                               "========================= ======== ======= $userWhoCanMessage");
//                           if (userWhoCanMessage.isNotEmpty) {
//                             return ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: snapshot.data!.docs.length,
//                               physics: const NeverScrollableScrollPhysics(),
//                               padding: const EdgeInsets.only(bottom: 85),
//                               itemBuilder: (context, index) {
//                                 if (userWhoCanMessage.contains(
//                                     snapshot.data!.docs[index].data()['id'])) {
//                                   final UserModel userMmessage =
//                                       UserModel.fromMap(
//                                           snapshot.data!.docs[index].data());
//                                   final CreatorDetails creatorDetails =
//                                       CreatorDetails.fromMap(
//                                           snapshot.data!.docs[index].data());
//                                   var val11 = generateRandomString(7);
//                                   return StreamBuilder<DocumentSnapshot<Map>>(
//                                     stream: FirebaseFirestore.instance
//                                         .collection("users")
//                                         .doc(FirebaseAuth
//                                             .instance.currentUser!.uid)
//                                         .collection("ghostMessageList")
//                                         .doc(userMmessage.id)
//                                         .snapshots(),
//                                     builder: (context, d) {
//                                       if (d.hasData && d.data!.exists) {
//                                         return Container();
//                                       } else {
//                                         // noChatUser.add(creatorDetails);
//                                         if (chatListController
//                                             .searchController.text.isNotEmpty) {
//                                           if (compareStrings(
//                                               userMmessage.name,
//                                               chatListController
//                                                   .searchController.text)) {
//                                             return SizedBox(
//                                               height: 70,
//                                               child: ListTile(
//                                                 onTap: () {
//                                                   Get.to(
//                                                     () => GhostChatScreen2(
//                                                       appUserId:
//                                                           userMmessage.id,
//                                                       creatorDetails:
//                                                           creatorDetails,
//                                                       profileScreenController:
//                                                           profileScreenController,
//                                                       val: val11,
//                                                     ),
//                                                   );
//                                                 },
//                                                 title: Row(
//                                                   children: [
//                                                     const Text(
//                                                       "Ghost----------",
//                                                       style: TextStyle(
//                                                           color:
//                                                               colorPrimaryA05,
//                                                           fontSize: 12),
//                                                     ),
//                                                     Text(
//                                                       val11,
//                                                     ),
//                                                     widthBox(5.w),
//                                                     Visibility(
//                                                         visible: creatorDetails
//                                                             .isVerified,
//                                                         child: SvgPicture.asset(
//                                                             icVerifyBadge))
//                                                   ],
//                                                 ),
//                                                 subtitle: TextWidget(
//                                                   text:
//                                                       'Start a conversation with ${profileScreenController.isGhostModeOn.value ? "Ghost" : userMmessage.name}',
//                                                   textOverflow:
//                                                       TextOverflow.ellipsis,
//                                                   fontWeight: FontWeight.w400,
//                                                   fontSize: 14.sp,
//                                                   color:
//                                                       const Color(0xff8a8a8a),
//                                                 ),
//                                                 leading: const CircleAvatar(
//                                                   child: Icon(
//                                                     Icons.question_mark,
//                                                   ),
//                                                 ),
//                                                 trailing: const Icon(
//                                                     Icons.navigate_next),
//                                               ),
//                                             );
//                                           } else {
//                                             return Container();
//                                           }
//                                         } else {
//                                           return SizedBox(
//                                             height: 70,
//                                             child: ListTile(
//                                               onTap: () {
//                                                 Get.to(
//                                                   () => GhostChatScreen2(
//                                                     appUserId: userMmessage.id,
//                                                     creatorDetails:
//                                                         creatorDetails,
//                                                     profileScreenController:
//                                                         profileScreenController,
//                                                     val: val11,
//                                                   ),
//                                                 );
//                                               },
//                                               title: Row(
//                                                 children: [
//                                                   const Text(
//                                                     "Ghost--------",
//                                                     style: TextStyle(
//                                                         color: colorPrimaryA05,
//                                                         fontSize: 12),
//                                                   ),
//                                                   Text(
//                                                     val11,
//                                                   ),
//                                                   widthBox(5.w),
//                                                 ],
//                                               ),
//                                               subtitle: TextWidget(
//                                                 text:
//                                                     'Start a conversation with Ghost',
//                                                 textOverflow:
//                                                     TextOverflow.ellipsis,
//                                                 fontWeight: FontWeight.w400,
//                                                 fontSize: 14.sp,
//                                                 color: const Color(0xff8a8a8a),
//                                               ),
//                                               leading: const CircleAvatar(
//                                                 child: Icon(
//                                                   Icons.question_mark,
//                                                 ),
//                                               ),
//                                               trailing: const Icon(
//                                                   Icons.navigate_next),
//                                             ),
//                                           );
//                                         }
//                                       }
//                                     },
//                                   );
//                                 } else {
//                                   return Container();
//                                 }
//                               },
//                             );
//                           } else {
//                             return const Center(
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 40),
//                                 child: Text(
//                                   "Please start follow people to start conversation with them",
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             );
//                           }
//                         } else if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const CircularProgressIndicator();
//                         } else {
//                           return const Center(
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 40),
//                               child: Text(
//                                 "Please start follow people to start conversation with them",
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     );
//                   } else {
//                     return const CircularProgressIndicator();
//                   }
//                 },
//               ),
//               const SizedBox(height: 90)
//             ],
//           ),
//         ),
//         Visibility(
//           visible: isLoading,
//           child: Container(
//             alignment: Alignment.center,
//             child: const CircularProgressIndicator(),
//           ),
//         )
//       ],
//     );
//   }
// }
