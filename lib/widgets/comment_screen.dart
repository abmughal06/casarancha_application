import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_chat_screen.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_controller.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/widgets/text_editing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/comment_model.dart';
import '../resources/color_resources.dart';
import '../resources/firebase_cloud_messaging.dart';
import '../resources/image_resources.dart';
import '../resources/localization_text_strings.dart';
import '../resources/strings.dart';
import 'PostCard/PostCardController.dart';
import 'clip_pad_shadow.dart';

// ignore: must_be_immutable
class CommentScreen extends StatelessWidget {
  CommentScreen(
      {Key? key,
      required this.id,
      required this.creatorId,
      required this.comment,
      required this.creatorDetails})
      : super(key: key);

  String id;
  List comment;
  final coommenController = TextEditingController();
  CreatorDetails creatorDetails;
  String? creatorId;
  PostCardController? postCardController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .doc(id)
                      .collection("comments")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data();
                          // var cDetail =
                          //     CreatorDetails.fromMap(data['creatorDetails']);
                          var cmnt = Comment.fromMap(data);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              horizontalTitleGap: 0,
                              leading: Container(
                                height: 30.h,
                                width: 30.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.amber,
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        cmnt.creatorDetails.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(cmnt.creatorDetails.name,
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w700)),
                              subtitle: Text(cmnt.message,
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400)),
                              trailing: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  timeago.format(
                                    DateTime.parse(
                                      cmnt.createdAt,
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 11.sp, color: Colors.black45),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              // SizedBox(
              //   height: 70.h,
              //   width: MediaQuery.of(context).size.width * .9,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Expanded(
              //         child: TextEditingWidget(
              //           controller: coommenController,
              //           color: Colors.black12,
              //           isBorderEnable: true,
              //           hint: "Write Comment ...",
              //         ),
              //       ),
              //       IconButton(
              //           onPressed: () async {
              //             print(
              //                 "================================== >>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<< kdasnaldaldkalkds");
              //             var cmnt = Comment(
              //               id: id,
              //               creatorId: FirebaseAuth.instance.currentUser!.uid,
              //               creatorDetails: CreatorDetails(
              //                   name: user!.name,
              //                   imageUrl: user!.imageStr,
              //                   isVerified: user!.isVerified),
              //               createdAt: DateTime.now().toIso8601String(),
              //               message: coommenController.text,
              //             );

              //             print(
              //                 "================================== >>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<< kdasnaldaldkalkds");

              //             // FirebaseFirestore.instance
              //             //     .collection("posts")
              //             //     .doc(id)
              //             //     .collection("comments")
              //             //     .doc()
              //             //     .set(cmnt.toMap(), SetOptions(merge: true))
              //             //     .then((value) async {
              //             //   coommenController.clear();
              //             //   var cmntId = await FirebaseFirestore.instance
              //             //       .collection("posts")
              //             //       .doc(id)
              //             //       .collection("comments")
              //             //       .get();

              //             //   List listOfCommentsId = [];
              //             //   for (var i in cmntId.docs) {
              //             //     listOfCommentsId.add(i.id);
              //             //   }

              //             //   print(
              //             //       "+++========+++++++++============+++++++++ $listOfCommentsId ");
              //             //   FirebaseFirestore.instance
              //             //       .collection("posts")
              //             //       .doc(id)
              //             //       .set({"commentIds": listOfCommentsId},
              //             //           SetOptions(merge: true));
              //             // }).whenComplete(() async {

              //             // });
              //             var recieverRef = await FirebaseFirestore.instance
              //                 .collection("users")
              //                 .doc(creatorId)
              //                 .get();

              //             var recieverFCMToken =
              //                 recieverRef.data()!['fcmToken'];
              //             print(
              //                 "=========>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> reciever fcm token = $recieverFCMToken");
              //             await FirebaseMessagingService()
              //                 .sendNotificationToUser(
              //               creatorDetails: CreatorDetails(
              //                   name: cmnt.creatorDetails.name,
              //                   imageUrl: cmnt.creatorDetails.imageUrl,
              //                   isVerified: cmnt.creatorDetails.isVerified),
              //               devRegToken: recieverFCMToken,
              //               userReqID: creatorId,
              //               title: user!.name,
              //               msg: "${user!.name} has commented on your post.",
              //             );
              //           },
              //           icon: const Icon(Icons.send)),
              //     ],
              //   ),
              // ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRect(
              clipper: const ClipPad(padding: EdgeInsets.only(top: 30)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(color: colorWhite, boxShadow: [
                  BoxShadow(
                    color: colorPrimaryA05.withOpacity(.36),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(4, 0),
                  ),
                ]),
                child: TextField(
                  controller: coommenController,
                  style: TextStyle(
                    color: color239,
                    fontSize: 16.sp,
                    fontFamily: strFontName,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: strWriteComment,
                    hintStyle: TextStyle(
                      color: color55F,
                      fontSize: 14.sp,
                      fontFamily: strFontName,
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                            onTap: () {
                              var cmnt = Comment(
                                id: id,
                                creatorId:
                                    FirebaseAuth.instance.currentUser!.uid,
                                creatorDetails: CreatorDetails(
                                    name: user!.name,
                                    imageUrl: user!.imageStr,
                                    isVerified: user!.isVerified),
                                createdAt: DateTime.now().toIso8601String(),
                                message: coommenController.text,
                              );

                              FirebaseFirestore.instance
                                  .collection("posts")
                                  .doc(id)
                                  .collection("comments")
                                  .doc()
                                  .set(cmnt.toMap(), SetOptions(merge: true))
                                  .then((value) async {
                                coommenController.clear();
                                var cmntId = await FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(id)
                                    .collection("comments")
                                    .get();

                                List listOfCommentsId = [];
                                for (var i in cmntId.docs) {
                                  listOfCommentsId.add(i.id);
                                }

                                print(
                                    "+++========+++++++++============+++++++++ $listOfCommentsId ");
                                FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(id)
                                    .set({"commentIds": listOfCommentsId},
                                        SetOptions(merge: true));
                                var recieverRef = await FirebaseFirestore
                                    .instance
                                    .collection("users")
                                    .doc(creatorId)
                                    .get();

                                var recieverFCMToken =
                                    recieverRef.data()!['fcmToken'];
                                print(
                                    "=========>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> reciever fcm token = $recieverFCMToken");
                                await FirebaseMessagingService()
                                    .sendNotificationToUser(
                                  creatorDetails: CreatorDetails(
                                      name: cmnt.creatorDetails.name,
                                      imageUrl: cmnt.creatorDetails.imageUrl,
                                      isVerified:
                                          cmnt.creatorDetails.isVerified),
                                  devRegToken: recieverFCMToken,
                                  userReqID: creatorId,
                                  title: user!.name,
                                  msg:
                                      "${user!.name} has commented on your post.",
                                );
                              });
                            },
                            child: Image.asset(
                              imgSendComment,
                              height: 38.h,
                              width: 38.w,
                            ))),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                    focusColor: Colors.transparent,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
