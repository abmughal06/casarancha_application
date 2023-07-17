import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../resources/image_resources.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_widget.dart';

class SharePostScreen extends StatelessWidget {
  const SharePostScreen({Key? key, required this.postModel}) : super(key: key);
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    List<String> messageUserIds = [];
    return Scaffold(
      body: ListView(
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
          Consumer<List<MessageDetails>?>(
            builder: (context, msg, b) {
              if (msg == null) {
                return const CircularProgressIndicator();
              }
              messageUserIds = msg.map((e) => e.id).toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: msg.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var isSent = false.obs;
                  return SharePostTile(
                      messageDetails: msg[index], isSent: isSent);
                },
              );
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

                var isSent = false.obs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filterList.length,
                  itemBuilder: (context, index) {
                    return SharePostTileForNewFreind(
                        userModel: filterList[index], isSent: isSent);
                  },
                );
              }
            },
          ),
          const SizedBox(height: 90)
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

class SharePostTile extends StatelessWidget {
  const SharePostTile(
      {Key? key, required this.messageDetails, required this.isSent})
      : super(key: key);
  final MessageDetails messageDetails;
  final Rx<bool> isSent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListTile(
        title: Text(messageDetails.creatorDetails.name),
        subtitle: Text(
          messageDetails.lastMessage,
          overflow: TextOverflow.ellipsis,
        ),
        leading: CircleAvatar(
          backgroundImage: messageDetails.creatorDetails.imageUrl.isEmpty
              ? null
              : CachedNetworkImageProvider(
                  messageDetails.creatorDetails.imageUrl,
                ),
          child: messageDetails.creatorDetails.imageUrl.isEmpty
              ? const Icon(
                  Icons.question_mark,
                )
              : null,
        ),
        trailing: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: isSent.value ? Colors.red.shade300 : Colors.red.shade900,
              borderRadius: BorderRadius.circular(30),
            ),
            child: InkWell(
              onTap: () async {
                // ChatController()x
                // final messageRefForCurrentUser = FirebaseFirestore.instance
                //     .collection("users")
                //     .doc(FirebaseAuth.instance.currentUser!.uid)
                //     .collection('messageList')
                //     .doc(appUserId)
                //     .collection('messages')
                //     .doc();

                // final messageRefForAppUser = FirebaseFirestore.instance
                //     .collection("users")
                //     .doc(appUserId)
                //     .collection('messageList')
                //     .doc(FirebaseAuth.instance.currentUser!.uid)
                //     .collection('messages')
                //     .doc(
                //       messageRefForCurrentUser.id,
                //     );

                // var post = postModel.toMap();

                // final Message message = Message(
                //   id: messageRefForCurrentUser.id,
                //   sentToId: appUserId,
                //   sentById: FirebaseAuth.instance.currentUser!.uid,
                //   content: post,
                //   caption: '',
                //   type: postModel.mediaData[0].type,
                //   createdAt: DateTime.now().toIso8601String(),
                //   isSeen: false,
                // );
                // print(
                //     "============= ------------------- ------- --= ====== ==== $message");
                // final appUserMessage =
                //     message.copyWith(id: messageRefForAppUser.id);

                // messageRefForCurrentUser.set(message.toMap());
                // messageRefForAppUser.set(appUserMessage.toMap());
                // isSent.value = true;
                // var recieverRef = await FirebaseFirestore.instance
                //     .collection("users")
                //     .doc(appUserId)
                //     .get();

                // var recieverFCMToken = recieverRef.data()!['fcmToken'];
                // print("=========> reciever fcm token = $recieverFCMToken");
                // FirebaseMessagingService().sendNotificationToUser(
                //   appUserId: recieverRef.id,
                //   devRegToken: recieverFCMToken,
                //   msg: "has sent you a post",
                //   imageUrl: postModel.mediaData[0].type != 'Video'
                //       ? postModel.mediaData[0].link
                //       : "",
                // );

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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                child: Text(
                  isSent.value ? "Sent" : "Send",
                  style: const TextStyle(
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
  }
}

class SharePostTileForNewFreind extends StatelessWidget {
  const SharePostTileForNewFreind(
      {Key? key, required this.userModel, required this.isSent})
      : super(key: key);

  final UserModel userModel;
  final Rx<bool> isSent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListTile(
        title: Row(
          children: [
            TextWidget(
              text: userModel.name,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff222939),
            ),
            widthBox(5.w),
            Visibility(
                visible: userModel.isVerified,
                child: SvgPicture.asset(icVerifyBadge))
          ],
        ),
        subtitle: TextWidget(
          text: 'Start a conversation with ${userModel.name}',
          textOverflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: const Color(0xff8a8a8a),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.yellow,
          backgroundImage: CachedNetworkImageProvider(
            userModel.imageStr,
          ),
        ),
        trailing: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: isSent.value ? Colors.red.shade300 : Colors.red.shade900,
              borderRadius: BorderRadius.circular(30),
            ),
            child: InkWell(
              onTap: () async {
                // ChatController()x
                // final messageRefForCurrentUser = FirebaseFirestore.instance
                //     .collection("users")
                //     .doc(FirebaseAuth.instance.currentUser!.uid)
                //     .collection('messageList')
                //     .doc(appUserId)
                //     .collection('messages')
                //     .doc();

                // final messageRefForAppUser = FirebaseFirestore.instance
                //     .collection("users")
                //     .doc(appUserId)
                //     .collection('messageList')
                //     .doc(FirebaseAuth.instance.currentUser!.uid)
                //     .collection('messages')
                //     .doc(
                //       messageRefForCurrentUser.id,
                //     );

                // var post = postModel.toMap();

                // final Message message = Message(
                //   id: messageRefForCurrentUser.id,
                //   sentToId: appUserId,
                //   sentById: FirebaseAuth.instance.currentUser!.uid,
                //   content: post,
                //   caption: '',
                //   type: postModel.mediaData[0].type,
                //   createdAt: DateTime.now().toIso8601String(),
                //   isSeen: false,
                // );
                // print(
                //     "============= ------------------- ------- --= ====== ==== $message");
                // final appUserMessage =
                //     message.copyWith(id: messageRefForAppUser.id);

                // messageRefForCurrentUser.set(message.toMap());
                // messageRefForAppUser.set(appUserMessage.toMap());
                // isSent.value = true;
                // var recieverRef = await FirebaseFirestore.instance
                //     .collection("users")
                //     .doc(appUserId)
                //     .get();

                // var recieverFCMToken = recieverRef.data()!['fcmToken'];
                // print("=========> reciever fcm token = $recieverFCMToken");
                // FirebaseMessagingService().sendNotificationToUser(
                //   appUserId: recieverRef.id,
                //   devRegToken: recieverFCMToken,
                //   msg: "has sent you a post",
                //   imageUrl: postModel.mediaData[0].type != 'Video'
                //       ? postModel.mediaData[0].link
                //       : "",
                // );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                child: Text(
                  isSent.value ? "Sent" : "Send",
                  style: const TextStyle(
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
  }
}
