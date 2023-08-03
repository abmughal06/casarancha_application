import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
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
    final currentUser = context.watch<UserModel>();
    final users = context.watch<List<UserModel>?>();

    List<String> messageUserIds = [];
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
          Consumer<List<MessageDetails>?>(
            builder: (context, msg1, b) {
              if (msg1 == null || users == null) {
                return const CircularProgressIndicator.adaptive();
              }
              List<MessageDetails> msg = [];
              for (var m in msg1) {
                for (var u in users) {
                  if (m.id == u.id) {
                    msg.add(m);
                  }
                }
              }
              messageUserIds = msg.map((e) => e.id).toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: msg.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SharePostTile(
                    appUserId: msg[index].id,
                    currentUser: currentUser,
                    postModel: postModel,
                  );
                },
              );
            },
          ),
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
                var followingAndFollowersList = users
                    .where((element) =>
                        currentUser.followersIds.contains(element.id) ||
                        currentUser.followingsIds.contains(element.id))
                    .toList();

                List<UserModel> filterList = followingAndFollowersList
                    .where((element) => !messageUserIds.contains(element.id))
                    .toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filterList.length,
                  itemBuilder: (context, index) {
                    return SharePostTile(
                      // userModel: filterList[index],
                      appUserId: filterList[index].id,
                      postModel: postModel,
                      currentUser: currentUser,
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

class SharePostTile extends StatefulWidget {
  const SharePostTile({
    Key? key,
    // required this.messageDetails,
    required this.postModel,
    required this.currentUser,
    required this.appUserId,
  }) : super(key: key);
  // final MessageDetails messageDetails;
  final PostModel postModel;
  final UserModel currentUser;
  final String appUserId;

  @override
  State<SharePostTile> createState() => _SharePostTileState();
}

class _SharePostTileState extends State<SharePostTile> {
  late PostProvider postProvider;

  @override
  void dispose() {
    postProvider.disposeSendButton();
    super.dispose();
  }

  bool isSent = false;

  @override
  Widget build(BuildContext context) {
    postProvider = Provider.of<PostProvider>(context, listen: false);
    final users = context.watch<List<UserModel>>();
    final appUser =
        users.where((element) => element.id == widget.appUserId).first;
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
                CircleAvatar(
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
                onTap: () {
                  postProvider.sharePostData(
                    currentUser: widget.currentUser,
                    appUser: appUser,
                    postModel: widget.postModel,
                  );
                  setState(() {
                    isSent = true;
                  });
                },
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

class SharePostTileForNewFreind extends StatefulWidget {
  const SharePostTileForNewFreind({
    Key? key,
    required this.userModel,
    required this.postModel,
    required this.currentUser,
  }) : super(key: key);

  final UserModel userModel;
  final PostModel postModel;
  final UserModel currentUser;

  @override
  State<SharePostTileForNewFreind> createState() =>
      _SharePostTileForNewFreindState();
}

class _SharePostTileForNewFreindState extends State<SharePostTileForNewFreind> {
  late PostProvider postProvider;

  @override
  void dispose() {
    postProvider.disposeSendButton();
    super.dispose();
  }

  bool isSent = false;

  @override
  Widget build(BuildContext context) {
    postProvider = Provider.of<PostProvider>(context, listen: false);

    return SizedBox(
      height: 70,
      child: ListTile(
        title: Row(
          children: [
            TextWidget(
              text: widget.userModel.name,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff222939),
            ),
            widthBox(5.w),
            Visibility(
                visible: widget.userModel.isVerified,
                child: SvgPicture.asset(icVerifyBadge))
          ],
        ),
        subtitle: TextWidget(
          text: 'Start a conversation with ${widget.userModel.name}',
          textOverflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: const Color(0xff8a8a8a),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.yellow,
          backgroundImage: CachedNetworkImageProvider(
            widget.userModel.imageStr,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: isSent ? Colors.red.shade300 : Colors.red.shade900,
            borderRadius: BorderRadius.circular(30),
          ),
          child: InkWell(
            onTap: () {
              postProvider.sharePostData(
                currentUser: widget.currentUser,
                appUser: widget.userModel,
                postModel: widget.postModel,
              );
              setState(() {
                isSent = !isSent;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
              child: Text(
                isSent ? "Sent" : "Send",
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
    );
  }
}
