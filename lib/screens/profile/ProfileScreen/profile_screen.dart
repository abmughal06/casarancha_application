import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/screens/home/story_view_screen.dart';

import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/screens/profile/edit_profile_screen.dart';

import 'package:casarancha/screens/profile/saved_post_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/menu_post_button.dart';
import 'package:casarancha/widgets/primary_tabbar.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../resources/localization_text_strings.dart';

import '../../../utils/app_constants.dart';

import '../../../widgets/common_widgets.dart';
import '../../../widgets/home_page_widgets.dart';
import '../../../widgets/text_widget.dart';

import '../../auth/login_screen.dart';
import '../../chat/GhostMode/ghost_chat_helper.dart';
import '../follower_following_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileScreenController profileScreenController;
  @override
  void initState() {
    profileScreenController = Get.isRegistered<ProfileScreenController>()
        ? Get.find<ProfileScreenController>()
        : Get.put(ProfileScreenController());
    Future.delayed(Duration.zero, () async {
      profileScreenController.updatePostList();
    });
    super.initState();
  }

  Widget postFollowCount({required String count, required String strText}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget(
          text: count,
          color: color13F,
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
        ),
        heightBox(3.h),
        TextWidget(
          text: strText,
          color: colorAA3,
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
        ),
      ],
    );
  }

  Widget postStoriesBtn(
      {required String icon, required String text, required bool isSelected}) {
    return Expanded(
      child: SizedBox(
        height: 47.h,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon),
              widthBox(12.w),
              TextWidget(
                text: text,
                color: isSelected ? colorPrimaryA05 : colorAA3,
                fontSize: 14.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _bottomSheetProfile(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
        ),
        builder: (BuildContext context) {
          return Container(
              height: 550,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    heightBox(10.h),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 6.h,
                        width: 78.w,
                        decoration: BoxDecoration(
                          color: colorDD9,
                          borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        ),
                      ),
                    ),
                    heightBox(10.h),
                    Expanded(
                      child: ListView.builder(
                          itemCount: AppConstant.profileBottomSheetList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14.0),
                              child: textMenuItem(
                                  text:
                                      AppConstant.profileBottomSheetList[index],
                                  color: index > 6 ? Colors.red : null,
                                  onTap: () {
                                    _onTapSheetItem(index: index);
                                  }),
                            );
                          }),
                    )
                  ]));
        });
  }

  _onTapSheetItem({required int index}) async {
    switch (index) {
      case 0:
        Get.to(() => EditProfileScreen(
              currentUser: profileScreenController.user.value,
            ));
        break;
      case 1:
        Get.to(() => SavedPostScreen());
        break;
      case 2:
        //getVerify
        Get.back();
        GlobalSnackBar.show(message: 'Coming Soon');
        break;
      case 3:
        Get.back();
        GlobalSnackBar.show(message: 'Coming Soon');
        break;

      case 4:
        //about
        Get.back();
        launchUrls("https://casarancha.com/about/");
        break;

      case 5:
        //terms

        Get.back();
        launchUrls("https://casarancha.com/terms-conditions/");
        break;
      case 6:
        //privacy

        Get.back();
        launchUrls("https://casarancha.com/privacy-policy/");
        break;
      case 7:
        //logout
        profileScreenController.logout();

        break;
      case 8:
        //logout

        showDialog(
            context: context,
            builder: (context) {
              return deleteAccountDialog(context);
            });

        break;
    }
  }

  void launchUrls(String url) async {
    Uri? uri = Uri.tryParse(url);
    if (uri != null) {
      if (await canLaunchUrl(uri)) {
        launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        log("Can't launch url => $url");
      }
    } else {
      log("$url is not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var user = UserModel.fromMap(snapshot.data!.data()!);
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: ghostModeBtn(iconSize: 40),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    _bottomSheetProfile(context);
                                  },
                                  icon: Image.asset(
                                    imgProfileOption,
                                    height: 35.h,
                                    width: 35.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: colorPrimaryA05, width: 1.5),
                                shape: BoxShape.circle),
                            height: 90.h,
                            width: 90.h,
                            alignment: Alignment.center,
                            child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: ClipOval(
                                    child: FadeInImage(
                                        fit: BoxFit.cover,
                                        placeholder: const AssetImage(
                                            imgUserPlaceHolder),
                                        image: NetworkImage(user.imageStr)))),
                          ),
                          heightBox(15.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextWidget(
                                text: user.name,
                                color: color13F,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                              widthBox(6.w),
                              if (user.isVerified)
                                SvgPicture.asset(
                                  icVerifyBadge,
                                  width: 17.w,
                                  height: 17.h,
                                )
                            ],
                          ),
                          TextWidget(
                            text: user.username,
                            color: colorAA3,
                            fontSize: 12.sp,
                          ),
                          heightBox(12.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              StreamBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                  stream: FirebaseFirestore.instance
                                      .collection("posts")
                                      .where("creatorId",
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return postFollowCount(
                                          count: snapshot.data!.docs.length
                                              .toString(),
                                          strText: strProfilePost);
                                    } else {
                                      return postFollowCount(
                                          count: "0", strText: strProfilePost);
                                    }
                                  }),
                              verticalLine(
                                  height: 24.h, horizontalMargin: 30.w),
                              GestureDetector(
                                onTap: () => Get.to(() =>
                                    const CurruentUserFollowerFollowingScreen()),
                                child: postFollowCount(
                                    count: user.followersIds.length.toString(),
                                    strText: strProfileFollowers),
                              ),
                              verticalLine(
                                  height: 24.h, horizontalMargin: 30.w),
                              GestureDetector(
                                onTap: () => Get.to(() =>
                                    const CurruentUserFollowerFollowingScreen()),
                                child: postFollowCount(
                                    count: user.followingsIds.length.toString(),
                                    strText: strProfileFollowing),
                              ),
                            ],
                          ),
                          heightBox(14.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 27.w),
                            child: TextWidget(
                              text: profileScreenController.user.value.bio,
                              textAlign: TextAlign.center,
                              color: color55F,
                              fontSize: 12.sp,
                            ),
                          ),
                          heightBox(20.h),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: ghostModeBtn(iconSize: 40),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    _bottomSheetProfile(context);
                                  },
                                  icon: Image.asset(
                                    imgProfileOption,
                                    height: 35.h,
                                    width: 35.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: colorPrimaryA05, width: 1.5),
                                shape: BoxShape.circle),
                            height: 90.h,
                            width: 90.h,
                            alignment: Alignment.center,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Image.asset(imgUserPlaceHolder),
                            ),
                          ),
                          heightBox(15.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextWidget(
                                text: "-----",
                                color: color13F,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                              widthBox(6.w),
                            ],
                          ),
                          TextWidget(
                            text: "-----",
                            color: colorAA3,
                            fontSize: 12.sp,
                          ),
                          heightBox(12.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              postFollowCount(
                                  count: "0", strText: strProfilePost),
                              verticalLine(
                                  height: 24.h, horizontalMargin: 30.w),
                              GestureDetector(
                                onTap: () => Get.to(() =>
                                    const CurruentUserFollowerFollowingScreen()),
                                child: postFollowCount(
                                    count: "0", strText: strProfileFollowers),
                              ),
                              verticalLine(
                                  height: 24.h, horizontalMargin: 30.w),
                              GestureDetector(
                                onTap: () => Get.to(() =>
                                    const CurruentUserFollowerFollowingScreen()),
                                child: postFollowCount(
                                    count: "0", strText: strProfileFollowing),
                              ),
                            ],
                          ),
                          heightBox(14.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 27.w),
                            child: TextWidget(
                              text: profileScreenController.user.value.bio,
                              textAlign: TextAlign.center,
                              color: color55F,
                              fontSize: 12.sp,
                            ),
                          ),
                          heightBox(20.h),
                        ],
                      );
                    }
                  }),
            )
          ],
          body: DefaultTabController(
            length: 4,
            child: Column(
              children: [
                primaryTabBar(
                  tabs: const [
                    Tab(
                      child: Text('Quotes'),
                    ),
                    Tab(
                      child: Text('Images'),
                    ),
                    Tab(
                      child: Text('Videos'),
                    ),
                    Tab(
                      child: Text('Stories'),
                    ),
                  ],
                ),
                heightBox(10.w),
                Expanded(
                  child: TabBarView(
                    children: [
                      //qoute
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("posts")
                            .where("creatorId",
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var postdata = snapshot.data!.docs;
                            // var mediaDataList = [];
                            var qoutesList = [];

                            for (var i = 0; i < postdata.length; i++) {
                              if (postdata[i].data()['mediaData'] != []) {
                                if (postdata[i].data()['mediaData'][0]
                                        ['type'] ==
                                    'Qoute') {
                                  qoutesList.add(postdata[i].data());
                                  // print(qoutesList);
                                }
                              }
                            }
                            if (qoutesList.length.isEqual(0)) {
                              return Center(
                                child: TextWidget(
                                  text: "No qoutes to show",
                                ),
                              );
                            } else {
                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemCount: qoutesList.length,
                                itemBuilder: (context, index) {
                                  final data =
                                      PostModel.fromMap(qoutesList[index]);
                                  final String quote = data.mediaData[0].link;
                                  // print(quote);
                                  return Card(
                                    elevation: 0,
                                    margin: EdgeInsets.zero,
                                    color: Colors.transparent,
                                    child: GestureDetector(
                                      onTap: () => Get.to(() => Card(
                                            elevation: 0,
                                            margin: EdgeInsets.zero,
                                            color: Colors.transparent,
                                            child: Stack(
                                              children: [
                                                FullScreenQoute(
                                                  qoute: quote,
                                                  post: data,
                                                  profileScreenController:
                                                      profileScreenController,
                                                ),
                                              ],
                                            ),
                                          )),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          width: 0.1,
                                          color: Colors.grey,
                                        )),
                                        alignment: Alignment.center,
                                        child: Text(
                                          quote.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Center(
                              child: TextWidget(
                                text: "No qoutes to show",
                              ),
                            );
                          }
                        },
                      ),
                      //photo
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("posts")
                            .where("creatorId",
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var postdata = snapshot.data!.docs;
                            // var mediaDataList = [];
                            var qoutesList = [];

                            for (var i = 0; i < postdata.length; i++) {
                              if (postdata[i].data()['mediaData'] != []) {
                                if (postdata[i].data()['mediaData'][0]
                                        ['type'] ==
                                    'Photo') {
                                  qoutesList.add(postdata[i].data());
                                  // print(qoutesList);
                                }
                              }
                            }
                            if (qoutesList.length.isEqual(0)) {
                              return const Center(
                                child: Text("No Photos to show"),
                              );
                            } else {
                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemCount: qoutesList.length,
                                itemBuilder: (context, index) {
                                  final data =
                                      PostModel.fromMap(qoutesList[index]);
                                  final String quote = data.mediaData[0].link;
                                  // print(quote);
                                  return Card(
                                    elevation: 0,
                                    margin: EdgeInsets.zero,
                                    color: Colors.transparent,
                                    child: GestureDetector(
                                      onTap: () => Get.to(() => FullScreenImage(
                                          image: quote, post: data)),
                                      child: CachedNetworkImage(
                                        imageUrl: quote,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      //video
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("posts")
                            .where("creatorId",
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var postdata = snapshot.data!.docs;
                            // var mediaDataList = [];
                            var videoList = [];
                            var postid = "";
                            var creatorId = "";

                            for (var i = 0; i < postdata.length; i++) {
                              var postmodel =
                                  PostModel.fromMap(postdata[i].data());

                              for (var j = 0;
                                  j < postmodel.mediaData.length;
                                  j++) {
                                if (postmodel.mediaData != []) {
                                  if (postmodel.mediaData[j].type == 'Video') {
                                    videoList.add(postmodel.mediaData[j]);
                                    postid = postmodel.id;
                                    creatorId = postmodel.creatorId;
                                    print(videoList);
                                  }
                                }
                              }
                            }
                            if (videoList.length.isEqual(0)) {
                              return const Center(
                                child: Text("No Vdeos to show"),
                              );
                            } else {
                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 1,
                                ),
                                itemCount: videoList.length,
                                itemBuilder: (context, index) {
                                  final data = videoList[index];
                                  // print(quote);
                                  VideoPlayerController videoPlayerController =
                                      VideoPlayerController.network(data.link);
                                  videoPlayerController.initialize();
                                  videoPlayerController.pause();

                                  return GestureDetector(
                                      onTap: () => Get.to(() => FullScreenVideo(
                                            videoPlayerController:
                                                videoPlayerController,
                                            postId: postid,
                                            creatorId: creatorId,
                                          )),
                                      child:
                                          VideoPlayer(videoPlayerController));
                                },
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      //story
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("stories")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          log("======================== daldjalsdjlsdasl  ${snapshot.data}");
                          if (snapshot.hasData && snapshot.data != null) {
                            if (snapshot.data!.data() == null) {
                              return Center(
                                child: TextWidget(
                                  text: "No Stories are available to show",
                                ),
                              );
                            } else {
                              log("==================== snapshot has data");
                              // var listofData = snapshot.data!.docs;
                              // log(snapshot.data!.data());
                              dynamic map;
                              Story? story;

                              // var data = snapshot.data!.data();
                              // if (snapshot.data!.docs.isNotEmpty) {

                              map = snapshot.data!.data();
                              story = Story.fromMap(map);

                              DateTime? givenDate;
                              for (int i = 0;
                                  i < story.mediaDetailsList.length;
                                  i++) {
                                givenDate = DateTime.parse(
                                    story.mediaDetailsList[i].id);
                              }

                              DateTime twentyFourHoursAgo = DateTime.now()
                                  .subtract(const Duration(hours: 24));
                              log(" ========== $twentyFourHoursAgo");

                              if (story.mediaDetailsList.isNotEmpty) {
                                return Column(
                                  children: [
                                    Stack(
                                      children: [
                                        givenDate!.isAfter(twentyFourHoursAgo)
                                            ? GridView.builder(
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                ),
                                                itemCount:
                                                    profileScreenController
                                                        .userStories.length,
                                                itemBuilder: (context, index) {
                                                  final Story story =
                                                      profileScreenController
                                                          .userStories[index];
                                                  return GestureDetector(
                                                    onTap: () => Get.to(
                                                      () => StoryViewScreen(
                                                        story: story,
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons
                                                            .perm_media_rounded,
                                                        size: 48,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Center(
                                                child: TextWidget(
                                                  text:
                                                      "No Stories are available to show",
                                                ),
                                              ),
                                        givenDate.isAfter(twentyFourHoursAgo)
                                            ? GridView.builder(
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                ),
                                                itemCount:
                                                    profileScreenController
                                                        .userStories.length,
                                                itemBuilder: (context, index) {
                                                  final Story story =
                                                      profileScreenController
                                                          .userStories[index];
                                                  return GestureDetector(
                                                    onTap: () => Get.to(
                                                      () => StoryViewScreen(
                                                        story: story,
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons
                                                            .perm_media_rounded,
                                                        size: 48,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return Center(
                                  child: TextWidget(
                                    text: "No Stories are available to show",
                                  ),
                                );
                              }
                            }
                          } else if (snapshot.hasError) {
                            return const Text("Here");
                          } else if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return TextWidget(
                              text: "No Stories are available to show",
                            );
                            // return  Text('Story');
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenVideo extends StatefulWidget {
  FullScreenVideo(
      {Key? key, this.videoPlayerController, this.postId, this.creatorId})
      : super(key: key);

  ChewieController? chewieController;
  final VideoPlayerController? videoPlayerController;
  final String? postId;
  final String? creatorId;

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  @override
  void initState() {
    super.initState();
    widget.chewieController = ChewieController(
      autoPlay: true,
      aspectRatio: 9 / 16,
      videoPlayerController: widget.videoPlayerController!,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.chewieController!.pause();
    widget.chewieController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Chewie(
                controller: widget.chewieController!,
              ),
            ),
          ),
          Visibility(
            visible: widget.creatorId == FirebaseAuth.instance.currentUser!.uid,
            child: Positioned(
              top: 40,
              right: 15,
              child: InkWell(
                onTap: () {
                  Get.bottomSheet(
                    Container(
                      decoration: const BoxDecoration(color: Colors.red),
                      height: 80,
                      child: InkWell(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection("posts")
                              .doc(widget.postId)
                              .delete()
                              .then((value) => Get.back())
                              .whenComplete(() => Get.back());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: "Delete Post",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    isScrollControlled: true,
                  );
                  // Get.back();
                },
                child: Container(
                  height: 30.h,
                  width: 30.h,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: SvgPicture.asset(icThreeDots),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 15,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: SvgPicture.asset(icIosBackArrow),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FullScreenQoute extends StatelessWidget {
  const FullScreenQoute(
      {Key? key,
      required this.qoute,
      required this.post,
      this.profileScreenController})
      : super(key: key);
  final String qoute;
  final PostModel post;
  final ProfileScreenController? profileScreenController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Visibility(
            visible: post.creatorId == FirebaseAuth.instance.currentUser!.uid,
            child: InkWell(
              onTap: () {
                Get.bottomSheet(
                  Container(
                    decoration: const BoxDecoration(color: Colors.red),
                    height: 80,
                    child: InkWell(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection("posts")
                            .doc(post.id)
                            .delete()
                            .then((value) => Get.back())
                            .whenComplete(() => Get.back());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: "Delete Post",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  isScrollControlled: true,
                );
              },
              child: Container(
                height: 30.h,
                width: 30.h,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                child: SvgPicture.asset(icThreeDots),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          qoute,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  const FullScreenImage(
      {Key? key,
      required this.image,
      required this.post,
      this.profileScreenController})
      : super(key: key);
  final String image;
  final PostModel post;
  final ProfileScreenController? profileScreenController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Visibility(
            visible: post.creatorId == FirebaseAuth.instance.currentUser!.uid,
            child: InkWell(
              onTap: () {
                Get.bottomSheet(
                  Container(
                    decoration: const BoxDecoration(color: Colors.red),
                    height: 80,
                    child: InkWell(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection("posts")
                            .doc(post.id)
                            .delete()
                            .then((value) => Get.back())
                            .whenComplete(() => Get.back());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: "Delete Post",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  isScrollControlled: true,
                );
              },
              child: Container(
                height: 30.h,
                width: 30.h,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                child: SvgPicture.asset(icThreeDots),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

deleteAccountDialog(context) {
  TextButton cancelBtn = TextButton(
      onPressed: () => Get.back(),
      child: const Text("Cancel", style: TextStyle(color: color229)));

  Text desc = Text("Are you sure you want to delete your account?",
      style: TextStyle(
          color: Colors.black, fontSize: 16.w, fontWeight: FontWeight.w500));
  Text title = Text("DELETE ACCOUNT",
      style: TextStyle(
          color: colorPrimaryA05, fontSize: 18.w, fontWeight: FontWeight.w700));
  TextEditingController passwordText = TextEditingController();
  bool isLoading = false;
  return StatefulBuilder(builder: (context, setState) {
    return isLoading
        ? Center(
            child: Container(
            height: 80,
            width: 80,
            color: Colors.white.withOpacity(0.7),
            alignment: Alignment.center,
            child: const Card(
              elevation: 0,
              color: Colors.transparent,
              child: CircularProgressIndicator(
                color: colorPrimaryA05,
              ),
            ),
          ))
        : Center(
            child: Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(10),
                child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: dialog(title: title, content: desc, actions: [
                      TextButton(
                          onPressed: () async {
                            if (FirebaseAuth.instance.currentUser != null) {
                              setState(() {
                                isLoading = true;
                              });
                              await deleteAccountFromId(
                                  FirebaseAuth.instance.currentUser!);
                              Get.back();
                              Get.back();
                              Get.off(() => const LoginScreen());
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: const Text("Ok",
                              style: TextStyle(color: colorPrimaryA05))),
                      cancelBtn
                    ]))));
  });
}

dialog(
    {Widget? title, Widget? content, List<Widget> actions = const <Widget>[]}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Align(alignment: Alignment.center, child: title),
      const SizedBox(height: 5),
      Align(alignment: Alignment.center, child: content),
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions.map((e) => e).toList(),
      )
    ],
  );
}

userUserIsNotMatched(
    context, FirebaseAuth auth, UserCredential? credential) async {
  if (credential != null) {
    User? user = credential.user;
    if (user != null) {
      if (user.uid == auth.currentUser?.uid) {
        await deleteAccountFromId(user);
        Get.back();
        Get.back();
        Get.off(() => const LoginScreen());
      } else {
        Get.back();
        showDialogUserIsNotMatched(context);
      }
    } else {
      Get.back();
      showDialogUserIsNotMatched(context);
    }
  } else {
    Get.back();
    showDialogUserIsNotMatched(context);
  }
}

void showDialogUserIsNotMatched(context) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("User is Not Matched"),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Ok"))
          ],
        );
      });
}

deleteAccountFromId(User user) async {
  String id = user.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    ProfileScreenController profileScreenController =
        Get.put(ProfileScreenController(isFromDelete: true));
    profileScreenController.setUserAgain();
    GhostChatHelper.shared.gMessageCtrl.disposeStream();
    await firestore
        .collection("posts")
        .where("creatorId", isEqualTo: id)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        if (element.exists) {
          await deletePost(PostModel.fromMap(element.data()));
        }
      }
    });
    await deleteStories(id);
    await deleteUser(id);
    FirebaseAuth.instance.signOut();
    await deleteUserFirebase(id);
  } catch (e) {
    Get.back();
    print("errors => $e");
  }
}

deleteUserFirebase(String uid) async {
  try {
    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable("deleteUserFromAuthentication");
    Map<String, dynamic> params = {
      "data": {"uid": uid}
    };
    final results = (await callable.call(jsonEncode(params))).data;
    return results;
  } on FirebaseFunctionsException catch (e) {
    print(e.code);
    print(e.details);
    throw Exception(e.message);
  }
}
