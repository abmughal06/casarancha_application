import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../resources/image_resources.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_widget.dart';

class SharePostScreen extends StatefulWidget {
  const SharePostScreen({Key? key, required this.postModel}) : super(key: key);
  final PostModel postModel;

  @override
  State<SharePostScreen> createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {
  late PostProvider postProvider;

  @override
  void dispose() {
    postProvider.restoreReciverList();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final currentUser = context.watch<UserModel>();
    // final users = context.watch<List<UserModel>?>();
    postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 20.h),
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
          // Consumer<List<MessageDetails>?>(
          //   builder: (context, msg1, b) {
          //     if (msg1 == null || users == null) {
          //       return const CircularProgressIndicator.adaptive();
          //     }
          //     List<MessageDetails> msg = [];
          //     for (var m in msg1) {
          //       for (var u in users) {
          //         if (m.id == u.id) {
          //           msg.add(m);
          //         }
          //       }
          //     }
          //     messageUserIds = msg.map((e) => e.id).toList();

          //     return ListView.builder(
          //       shrinkWrap: true,
          //       itemCount: msg.length,
          //       physics: const NeverScrollableScrollPhysics(),
          //       itemBuilder: (context, index) {
          //         return SharePostTile(
          //           appUser: users
          //               .where((element) => element.id == msg[index].id)
          //               .first,
          //           currentUser: currentUser,
          //           postModel: widget.postModel,
          //           isSent: postProvider.recieverIds.contains(msg[index].id),
          //           ontapSend: () {
          //             postProvider.sharePostData(
          //               currentUser: currentUser,
          //               appUser: users
          //                   .where((element) => element.id == msg[index].id)
          //                   .first,
          //               postModel: widget.postModel,
          //             );
          //           },
          //         );
          //       },
          //     );
          //   },
          // ),
          // const Divider(),
          Consumer<List<UserModel>?>(
            builder: (context, users, b) {
              if (users == null) {
                return Container();
              } else {
                var currentUser = users
                    .where((element) =>
                        element.id == FirebaseAuth.instance.currentUser!.uid)
                    .first;
                var filterList = users
                    .where((element) =>
                        currentUser.followersIds.contains(element.id) ||
                        currentUser.followingsIds.contains(element.id))
                    .toList();

                // List<UserModel> filterList = followingAndFollowersList
                //     .where((element) => !messageUserIds.contains(element.id))
                //     .toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filterList.length,
                  itemBuilder: (context, index) {
                    return SharePostTile(
                      // userModel: filterList[index],
                      appUser: filterList[index],
                      postModel: widget.postModel,
                      currentUser: currentUser,
                      isSent: postProvider.recieverIds
                          .contains(filterList[index].id),
                      ontapSend: () {
                        postProvider.sharePostData(
                          currentUser: currentUser,
                          appUser: filterList[index],
                          postModel: widget.postModel,
                        );
                      },
                    );
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
  const SharePostTile({
    Key? key,
    required this.postModel,
    required this.currentUser,
    required this.appUser,
    required this.isSent,
    required this.ontapSend,
  }) : super(key: key);

  final PostModel postModel;
  final UserModel currentUser;
  final UserModel appUser;
  final bool isSent;
  final VoidCallback ontapSend;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                appUser.imageStr != ''
                    ? CircleAvatar(
                        radius: 25,
                        backgroundImage: appUser.imageStr.isEmpty
                            ? null
                            : CachedNetworkImageProvider(
                                appUser.imageStr,
                              ),
                        child: appUser.imageStr.isEmpty
                            ? const Icon(
                                Icons.question_mark,
                              )
                            : null,
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 25,
                        backgroundImage: AssetImage(imgUserPlaceHolder),
                      ),
                widthBox(12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: appUser.username,
                      color: color221,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    heightBox(3.h),
                    TextWidget(
                      text: appUser.name,
                      color: colorAA3,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: isSent
                    ? colorPrimaryA05.withOpacity(0.16)
                    : colorPrimaryA05,
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: ontapSend,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                  child: TextWidget(
                    text: isSent ? "Sent" : "Send",
                    letterSpacing: 0.7,
                    color: isSent ? colorPrimaryA05 : colorFF3,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
