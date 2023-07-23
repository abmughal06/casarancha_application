import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/post_model.dart';
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
                  return SharePostTile(
                    messageDetails: msg[index],
                    currentUser: currentUser,
                    postModel: postModel,
                  );
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

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filterList.length,
                  itemBuilder: (context, index) {
                    return SharePostTileForNewFreind(
                      userModel: filterList[index],
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
    required this.messageDetails,
    required this.postModel,
    required this.currentUser,
  }) : super(key: key);
  final MessageDetails messageDetails;
  final PostModel postModel;
  final UserModel currentUser;

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

  @override
  Widget build(BuildContext context) {
    postProvider = Provider.of<PostProvider>(context, listen: false);
    final users = context.watch<List<UserModel>>();
    final appUser = users
        .where(
          (element) => element.id == widget.messageDetails.id,
        )
        .first;
    return SizedBox(
      height: 70,
      child: ListTile(
        title: Text(widget.messageDetails.creatorDetails.name),
        subtitle: Text(
          widget.messageDetails.lastMessage,
          overflow: TextOverflow.ellipsis,
        ),
        leading: CircleAvatar(
          backgroundImage: widget.messageDetails.creatorDetails.imageUrl.isEmpty
              ? null
              : CachedNetworkImageProvider(
                  widget.messageDetails.creatorDetails.imageUrl,
                ),
          child: widget.messageDetails.creatorDetails.imageUrl.isEmpty
              ? const Icon(
                  Icons.question_mark,
                )
              : null,
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color:
                postProvider.isSent ? Colors.red.shade300 : Colors.red.shade900,
            borderRadius: BorderRadius.circular(30),
          ),
          child: InkWell(
            onTap: () => postProvider.sharePostData(
              currentUser: widget.currentUser,
              appUser: appUser,
              postModel: widget.postModel,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
              child: Text(
                postProvider.isSent ? "Sent" : "Send",
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
            color:
                postProvider.isSent ? Colors.red.shade300 : Colors.red.shade900,
            borderRadius: BorderRadius.circular(30),
          ),
          child: InkWell(
            onTap: () => postProvider.sharePostData(
              currentUser: widget.currentUser,
              appUser: widget.userModel,
              postModel: widget.postModel,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
              child: Text(
                postProvider.isSent ? "Sent" : "Send",
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
