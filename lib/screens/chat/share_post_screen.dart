import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../models/message.dart';
import '../../models/message_details.dart';
import '../../models/post_creator_details.dart';
import '../../models/user_model.dart';
import '../../widgets/common_button.dart';
import 'Chat one-to-one/chat_screen.dart';
import 'ChatList/chat_list_screen.dart';

class SharePostScreen extends StatelessWidget {
  SharePostScreen({Key? key, required this.postModel}) : super(key: key);
  PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40.h),
          Row(
            children: [
              const Expanded(flex: 6, child: SizedBox()),
              Text(
                "Share Post",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              const Expanded(flex: 4, child: SizedBox()),
              InkWell(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.close,
                  size: 20.w,
                ),
              ),
              SizedBox(
                width: 20.w,
              )
            ],
          ),
          SizedBox(height: 20.h),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Text(
          //       "Share with Freinds",
          //       style: TextStyle(
          //           fontSize: 16.sp,
          //           color: Colors.black,
          //           fontWeight: FontWeight.w600),
          //     ),
          //     Text(
          //       "Share on social media",
          //       style: TextStyle(
          //           fontSize: 16.sp,
          //           color: Colors.black,
          //           fontWeight: FontWeight.w400),
          //     ),
          //   ],
          // ),
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
                        if (snapshot.hasData && snapshot.data != null) {
                          print(
                              "========================= ======== ======= $userWhoCanMessage");
                          if (userWhoCanMessage.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final UserModel userMmessage =
                                    UserModel.fromMap(
                                        snapshot.data!.docs[index].data());
                                final CreatorDetails creatorDetails =
                                    CreatorDetails.fromMap(
                                        snapshot.data!.docs[index].data());
                                var isSent = false.obs;
                                return SizedBox(
                                  height: 70,
                                  child: ListTile(
                                    // onTap: () {
                                    //   Get.to(
                                    //     () => ChatScreen(
                                    //       appUserId: userMmessage.id,
                                    //       creatorDetails: creatorDetails,
                                    //     ),
                                    //   );
                                    // },
                                    title: Text(userMmessage.name),
                                    subtitle:
                                        StreamBuilder<DocumentSnapshot<Map>>(
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
                                          var data =
                                              d.data!.data()!['lastMessage'];
                                          return Text(
                                            data!.toString(),
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        } else {
                                          return Text(
                                            'Send a Post to ${userMmessage.name}',
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }
                                      },
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          userMmessage.imageStr.isEmpty
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
                                    trailing: Obx(
                                      () => Container(
                                        decoration: BoxDecoration(
                                          color: isSent.value
                                              ? Colors.red.shade400
                                              : Colors.red.shade900,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            // ChatController()x
                                            final messageRefForCurrentUser =
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .collection('messageList')
                                                    .doc(userMmessage.id)
                                                    .collection('messages')
                                                    .doc();

                                            final messageRefForAppUser =
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(userMmessage.id)
                                                    .collection('messageList')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .collection('messages')
                                                    .doc(
                                                      messageRefForCurrentUser
                                                          .id,
                                                    );

                                            // final MessageDetails appUserMessageDetails = MessageDetails(
                                            //   id: FirebaseAuth.instance.currentUser!.uid,
                                            //   lastMessage: messageController.text,
                                            //   unreadMessageCount: unreadMessages + 1,
                                            //   searchCharacters: [...creatorDetails.name.toLowerCase().split('')],
                                            //   creatorDetails: CreatorDetails(
                                            //     name: creatorDetails.name,
                                            //     imageUrl: creatorDetails.imageUrl,
                                            //     isVerified: creatorDetails.isVerified,
                                            //   ),
                                            //   createdAt: DateTime.now().toIso8601String(),
                                            // );

                                            // final MessageDetails currentUserMessageDetails = MessageDetails(
                                            //   id: currentUserId,
                                            //   lastMessage: messageController.text,
                                            //   unreadMessageCount: unreadMessages + 1,
                                            //   searchCharacters: [
                                            //     ...profileScreenController.user.value.name.toLowerCase().split('')
                                            //   ],
                                            //   creatorDetails: CreatorDetails(
                                            //     name: profileScreenController.isGhostModeOn.value
                                            //         ? 'Ghost_${Random().nextInt(10000).toString()}'
                                            //         : profileScreenController.user.value.name,
                                            //     imageUrl: profileScreenController.isGhostModeOn.value
                                            //         ? ''
                                            //         : profileScreenController.user.value.imageStr,
                                            //     isVerified: profileScreenController.isGhostModeOn.value
                                            //         ? false
                                            //         : profileScreenController.user.value.isVerified,
                                            //   ),
                                            //   createdAt: DateTime.now().toIso8601String(),
                                            // );

                                            // if (!isChatExits.value) {
                                            //   await currentUserRef.collection('messageList').doc(appUserId).set(
                                            //         appUserMessageDetails.toMap(),
                                            //       );

                                            //   await appUserRef.collection('messageList').doc(currentUserId).set(
                                            //         currentUserMessageDetails.toMap(),
                                            //       );

                                            //   isChatExits.value = true;
                                            // }

                                            var post = postModel.toMap();

                                            final Message message = Message(
                                              id: messageRefForCurrentUser.id,
                                              sentToId: userMmessage.id,
                                              sentById: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              content: post,
                                              caption: '',
                                              type: postModel.mediaData[0].type,
                                              createdAt: DateTime.now()
                                                  .toIso8601String(),
                                              isSeen: false,
                                            );
                                            print(
                                                "============= ------------------- ------- --= ====== ==== $message");
                                            final appUserMessage =
                                                message.copyWith(
                                                    id: messageRefForAppUser
                                                        .id);

                                            messageRefForCurrentUser
                                                .set(message.toMap());
                                            messageRefForAppUser
                                                .set(appUserMessage.toMap());
                                            isSent.value = true;
                                            //   if (isChatExits.value) {
                                            //     appUserRef.collection('messageList').doc(currentUserId).update(
                                            //           currentUserMessageDetails.toMap(),
                                            //         );
                                            //     unreadMessages += 1;
                                            //   }

                                            //   messageController.clear();
                                            // } catch (e) {
                                            //   GlobalSnackBar(message: e.toString());
                                            // }
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 17, vertical: 9),
                                            child: Text(
                                              "Send",
                                              style: TextStyle(
                                                letterSpacing: 0.7,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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
                        } else {
                          return const CircularProgressIndicator();
                        }
                      });
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CommonButton(
        text: 'Done',
        height: 58.w,
        verticalOutMargin: 10.w,
        horizontalOutMargin: 10.w,
        onTap: () => Get.back(),
      ),
    );
  }
}
