import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_chat_screen.dart';
import 'package:casarancha/widgets/text_editing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/comment_model.dart';

// ignore: must_be_immutable
class CommentScreen extends StatelessWidget {
  CommentScreen(
      {Key? key,
      required this.id,
      required this.comment,
      required this.creatorDetails})
      : super(key: key);

  String id;
  List comment;
  final coommenController = TextEditingController();
  CreatorDetails creatorDetails;

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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(id)
                  .collection("comments")
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
          SizedBox(
            height: 70.h,
            width: MediaQuery.of(context).size.width * .9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextEditingWidget(
                    controller: coommenController,
                    color: Colors.black12,
                    isBorderEnable: true,
                    hint: "Write Comment ...",
                  ),
                ),
                IconButton(
                    onPressed: () {
                      var cmnt = Comment(
                        id: id,
                        creatorId: FirebaseAuth.instance.currentUser!.uid,
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
                      });
                    },
                    icon: const Icon(Icons.send)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
