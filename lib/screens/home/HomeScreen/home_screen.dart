import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_chat_screen.dart';
import 'package:casarancha/screens/home/HomeScreen/home_screen_controller.dart';
import 'package:casarancha/screens/home/CreateStory/add_story_screen.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';
import 'package:casarancha/widgets/asset_image_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:casarancha/widgets/video_player_Url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../models/comment_model.dart';
import '../../../models/post_creator_details.dart';
import '../../../resources/image_resources.dart';
import '../../../resources/localization_text_strings.dart';
import '../../../widgets/comment_screen.dart';
import '../../../widgets/common_widgets.dart';
import '../../chat/share_post_screen.dart';
import '../../dashboard/dashboard.dart';
import '../../profile/AppUser/app_user_controller.dart';
import '../../profile/AppUser/app_user_screen.dart';
import '../CreatePost/create_post_screen.dart';
import '../notification_screen.dart';
import '../story_view_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeScreenController = Get.put(HomeScreenController());
  String getFirstName(String fullName) {
    List<String> nameParts = fullName.split(" ");
    return nameParts[0];
  }

  Future<void>? initializedFuturePlay;

  // ProfileScreenController profileScreenController =
  //     Get.put(ProfileScreenController());

  @override
  void initState() {
    super.initState();
    // getPrefData();
  }

  List followingIds = [];
  List followerIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          strCasaRanch,
          style: TextStyle(
            color: color13F,
            fontFamily: strFontName,
            fontWeight: FontWeight.w700,
            fontSize: 22.sp,
          ),
        ),
        elevation: 0,
        leading: ghostModeBtn(homeCtrl: homeScreenController),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => CreatePostScreen());
            },
            icon: Image.asset(
              imgAddPost,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const NotificationScreen());
            },
            icon: badges.Badge(
              position: badges.BadgePosition.topEnd(end: -7, top: -6),
              child: SvgPicture.asset(
                icNotifyBell,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 10.w),
          SizedBox(
            // color: Colors.red,
            height: 85.h,
            child: Padding(
              padding: EdgeInsets.all(1.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("stories")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          log("======================== daldjalsdjlsdasl  ${snapshot.data}");
                          if (snapshot.hasData && snapshot.data != null) {
                            if (snapshot.data!.data() == null) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => AddStoryScreen());
                                },
                                child: SvgPicture.asset(
                                  icProfileAdd,
                                  height: 50.h,
                                  width: 50.w,
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

                              return Column(
                                // mainAxisAlignment:
                                // MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      givenDate!.isAfter(twentyFourHoursAgo)
                                          ? InkWell(
                                              onTap: () {
                                                Get.to(() => StoryViewScreen(
                                                    story: story!));
                                              },
                                              child: CircleAvatar(
                                                minRadius: 25,
                                                backgroundImage: NetworkImage(
                                                    map!["creatorDetails"]
                                                        ['imageUrl']),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                Get.to(() => AddStoryScreen());
                                              },
                                              child: SvgPicture.asset(
                                                icProfileAdd,
                                                height: 50.h,
                                                width: 50.w,
                                              ),
                                            ),
                                      givenDate.isAfter(twentyFourHoursAgo)
                                          ? Positioned(
                                              right: -2,
                                              bottom: -2,
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(
                                                      () => AddStoryScreen());
                                                },
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: colorPrimaryA05,
                                                    ),
                                                    child: const Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 18,
                                                    )),
                                              ))
                                          : Container(),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    "Your Story",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10),
                                  )
                                ],
                              );
                            }
                          } else if (snapshot.hasError) {
                            return const Text("Here");
                          } else if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => AddStoryScreen());
                              },
                              child: SvgPicture.asset(
                                icProfileAdd,
                                height: 50.h,
                                width: 50.w,
                              ),
                            );
                            // return  Text('Story');
                          }
                        }),
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snap) {
                        if (snap.hasData && snap.data!.exists) {
                          var userData = snap.data!.data();

                          if (userData!['followingsIds'] != [] &&
                              userData['followersIds'] != null) {
                            followingIds = userData['followingsIds'] != []
                                ? userData['followingsIds']
                                : [];

                            followerIds = userData['followersIds'] != []
                                ? userData['followersIds']
                                : [];
                            log(followingIds.toString());
                            log(followerIds.toString());
                            List storyIds = !homeScreenController
                                    .profileScreenController.isGhostModeOn.value
                                ? followingIds
                                : followerIds + followingIds;

                            log("storyiD ===============$storyIds");
                            // return Container();
                            return StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                              stream: storyIds.isEmpty
                                  ? FirebaseFirestore.instance
                                      .collection("stories")
                                      .where("creatorId",
                                          arrayContains: storyIds)
                                      .snapshots()
                                  : FirebaseFirestore.instance
                                      .collection("stories")
                                      .where(
                                        "creatorId",
                                        whereIn: storyIds,
                                      )
                                      .snapshots(),
                              builder: (context, snapshot) {
                                log(DateTime.now().toIso8601String());
                                if (snapshot.hasData && snapshot.data != null) {
                                  final data = snapshot.data!.docs;
                                  // double progress =
                                  // data.bytesTransferred / data.totalBytes;
                                  log("++++++++++++++++++++++++++++- $data");
                                  return Expanded(
                                    child: ListView.builder(
                                        // padding: EdgeInsets.only(top: 10.w),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          var storyData = data[index].data();

                                          Story story =
                                              Story.fromMap(storyData);
                                          DateTime? givenDate;
                                          for (int i = 0;
                                              i < story.mediaDetailsList.length;
                                              i++) {
                                            givenDate = DateTime.parse(
                                                story.mediaDetailsList[i].id);
                                          }

                                          DateTime twentyFourHoursAgo =
                                              DateTime.now().subtract(
                                                  const Duration(hours: 24));
                                          log(" ========== $twentyFourHoursAgo");
                                          if (givenDate!
                                              .isBefore(twentyFourHoursAgo)) {
                                            return Container();
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(
                                                        () => StoryViewScreen(
                                                            story: story),
                                                      );
                                                    },
                                                    child: CircleAvatar(
                                                      minRadius: 25,
                                                      backgroundImage:
                                                          NetworkImage(story
                                                              .creatorDetails
                                                              .imageUrl),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    getFirstName(story
                                                        .creatorDetails.name),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }),
                                  );

                                  // return Stack(
                                  //   children: [
                                  //     LinearProgressIndicator(
                                  //       value: progress,
                                  //     ),
                                  //     Center(
                                  //       child: Text(
                                  //         '${(100 * progress).roundToDouble()}%',
                                  //       ),
                                  //     )
                                  //   ],
                                  // );
                                } else {
                                  return const SizedBox(
                                    height: 50,
                                  );
                                }
                              },
                            );
                          } else {
                            return Container();
                          }
                          // return Text(snap.data!.data()!['followingsIds']);
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      })
                ],
              ),
            ),
          ),
          SizedBox(height: 10.w),
          homeScreenController.profileScreenController.isGhostModeOn.value
              ? StreamBuilder<QuerySnapshot>(
                  stream: homeScreenController.postQuerry.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                    if (snap.hasData) {
                      var data = snap.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final prePost =
                              data[index].data() as Map<String, dynamic>;
                          final post = PostModel.fromMap(prePost);
                          PostCardController postCardController =
                              PostCardController(postdata: post);
                          log("creator id==================");
                          log(postCardController.postdata.creatorId);
                          if (followingIds.contains(
                              postCardController.postdata.creatorId)) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: post.mediaData[0].type == "Photo",
                                    child: Column(
                                      children: [
                                        CustomPostHeader(
                                            name: post.creatorDetails.name,
                                            isVerified:
                                                post.creatorDetails.isVerified,
                                            image: post.creatorDetails.imageUrl,
                                            headerOnTap: () {
                                              postCardController
                                                  .gotoAppUserScreen(
                                                      post.creatorId);
                                            }),
                                        heightBox(10.h),
                                        AspectRatio(
                                          aspectRatio: 2 / 3,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: post.mediaData.length,
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                                    onTap: () => Get.to(() =>
                                                        PostDetailScreen(
                                                            postModel: post,
                                                            postCardController:
                                                                postCardController)),
                                                    onDoubleTap: () async {
                                                      log("ghost mode clicked");

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(const SnackBar(
                                                              backgroundColor:
                                                                  colorPrimaryA05,
                                                              content: Text(
                                                                  'Ghost Mode Enabled!')));
                                                    },
                                                    child: Image.network(post
                                                        .mediaData[index]
                                                        .link)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: post.mediaData[0].type == "Video",
                                    child: FutureBuilder(
                                        future: initializedFuturePlay,
                                        builder: (context, snapshot) {
                                          return Visibility(
                                            child: AspectRatio(
                                              aspectRatio: 9 / 16,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount:
                                                    post.mediaData.length,
                                                itemBuilder: (context, i) {
                                                  VideoPlayerController?
                                                      videoPlayerController;

                                                  videoPlayerController =
                                                      VideoPlayerController
                                                          .network(
                                                    post.mediaData.first.type ==
                                                            "Video"
                                                        ? post.mediaData[i].link
                                                            .toString()
                                                        : "",
                                                  );

                                                  return InkWell(
                                                    onTap: () => Get.to(() =>
                                                        PostDetailScreen(
                                                            postModel: post,
                                                            postCardController:
                                                                postCardController)),
                                                    onDoubleTap: () {
                                                      log("ghost mode clicked");

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(const SnackBar(
                                                              backgroundColor:
                                                                  colorPrimaryA05,
                                                              content: Text(
                                                                  'Ghost Mode Enabled!')));
                                                    },
                                                    child: AspectRatio(
                                                      aspectRatio: 9 / 16,
                                                      child: Stack(
                                                        children: [
                                                          VideoPlayerWidget(
                                                            videoPlayerController:
                                                                videoPlayerController,
                                                            videoUrl: post
                                                                .mediaData[i]
                                                                .link,
                                                          ),
                                                          Positioned(
                                                            top: 12,
                                                            left: 0,
                                                            right: 0,
                                                            child:
                                                                CustomPostHeader(
                                                              isVerified: post
                                                                  .creatorDetails
                                                                  .isVerified,
                                                              name: post
                                                                  .creatorDetails
                                                                  .name,
                                                              image: post
                                                                  .creatorDetails
                                                                  .imageUrl,
                                                              headerOnTap: () {
                                                                postCardController
                                                                    .gotoAppUserScreen(
                                                                        post.creatorId);
                                                              },
                                                              isVideoPost: true,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  Visibility(
                                    visible: post.mediaData[0].type == "Qoute",
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomPostHeader(
                                            isVerified:
                                                post.creatorDetails.isVerified,
                                            name: post.creatorDetails.name,
                                            image: post.creatorDetails.imageUrl,
                                            ontap: () {},
                                            time: timeago.format(
                                                DateTime.parse(post.createdAt)),
                                            headerOnTap: () {
                                              postCardController
                                                  .gotoAppUserScreen(
                                                      post.creatorId);
                                            }),
                                        SizedBox(
                                          height: 229,
                                          child: ListView.builder(
                                            // shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: post.mediaData.length,
                                            itemBuilder: (context, index) =>
                                                InkWell(
                                              onTap: () => Get.to(() =>
                                                  PostDetailScreen(
                                                      postModel: post,
                                                      postCardController:
                                                          postCardController)),
                                              onDoubleTap: () {
                                                log("ghost mode clicked");

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        backgroundColor:
                                                            colorPrimaryA05,
                                                        content: Text(
                                                            'Ghost Mode Enabled!')));
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 40,
                                                  vertical: 50,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    post.mediaData[index].link,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: color221,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  heightBox(10.h),
                                  CustomPostFooter(
                                    likes: post.likesIds.length.toString(),
                                    isLike: post.likesIds.contains(user!.id),

                                    ontapLike: () {
                                      log("ghost mode clicked");

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              backgroundColor: colorPrimaryA05,
                                              content:
                                                  Text('Ghost Mode Enabled!')));
                                    },
                                    // ontapSave: () {
                                    //   log(user!.savedPostsIds);

                                    // },
                                    saveBtn: StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var userData = snapshot.data!.data();
                                          var userModel =
                                              UserModel.fromMap(userData!);
                                          return GestureDetector(
                                            onTap: () {
                                              log("ghost mode clicked");

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                backgroundColor:
                                                    colorPrimaryA05,
                                                content:
                                                    Text('Ghost Mode Enabled!'),
                                              ));
                                            },
                                            child: Image.asset(
                                              postSave,
                                              color: userModel.savedPostsIds
                                                      .contains(post.id)
                                                  ? colorPrimaryA05
                                                  : null,
                                            ),
                                          );
                                        } else if (!snapshot.hasData) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          return Image.asset(postSave);
                                        }
                                      },
                                    ),
                                    ontapShare: () {
                                      log("ghost mode clicked");

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              backgroundColor: colorPrimaryA05,
                                              content:
                                                  Text('Ghost Mode Enabled!')));
                                    },
                                    ontapCmnt: () {
                                      log("ghost mode clicked");

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              backgroundColor: colorPrimaryA05,
                                              content:
                                                  Text('Ghost Mode Enabled!')));
                                    },
                                    comments: post.commentIds.length,
                                    isDesc: post.description.isNotEmpty,
                                    postId: post.id,
                                    isPostDetail: false,
                                    desc: post.description.toString(),
                                  ),
                                ],
                              ),
                            );
                            // log("contain================================");
                          } else {
                            return const SizedBox();
                            // log("not contain================================");
                          }
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )

              // ? Container(
              //     alignment: Alignment.center,
              //     child:  Text(
              //       "Please deactivate ghost mode to \nreturn to the home page",
              //       textAlign: TextAlign.center,
              //     ),
              //   )
              : StreamBuilder<QuerySnapshot>(
                  stream: homeScreenController.postQuerry.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                    if (snap.hasData) {
                      var data = snap.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final prePost =
                              data[index].data() as Map<String, dynamic>;
                          final post = PostModel.fromMap(prePost);
                          PostCardController postCardController =
                              PostCardController(postdata: post);
                          return Padding(
                            padding: EdgeInsets.only(bottom: 15.w),
                            child: Column(
                              children: [
                                Visibility(
                                  visible: post.mediaData[0].type != "Video",
                                  child: CustomPostHeader(
                                      isVerified:
                                          post.creatorDetails.isVerified,
                                      time: timeago.format(
                                          DateTime.parse(post.createdAt)),
                                      onVertItemClick: () {
                                        Get.back();

                                        Get.bottomSheet(
                                          BottomSheetWidget(
                                            ontapBlock: () {},
                                          ),
                                          isScrollControlled: true,
                                        );
                                      },
                                      name: post.creatorDetails.name,
                                      image: post.creatorDetails.imageUrl,
                                      ontap: () {},
                                      headerOnTap: () {
                                        postCardController
                                            .gotoAppUserScreen(post.creatorId);
                                      }),
                                ),
                                Visibility(
                                  visible: post.mediaData[0].type == "Photo",
                                  child: Column(
                                    children: [
                                      heightBox(10.h),
                                      AspectRatio(
                                        aspectRatio: 2 / 3,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: post.mediaData.length,
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                                  onTap: () => Get.to(() =>
                                                      PostDetailScreen(
                                                          postModel: post,
                                                          postCardController:
                                                              postCardController)),
                                                  onDoubleTap: () async {
                                                    log("clicked");
                                                    postCardController
                                                            .isLiked.value =
                                                        !post.likesIds
                                                            .contains(user!.id);
                                                    postCardController
                                                        .likeDisLikePost(
                                                            user!.id,
                                                            post.id,
                                                            post.creatorId);
                                                  },
                                                  child: Image.network(post
                                                      .mediaData[index].link)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: post.mediaData[0].type == "Video",
                                  child: FutureBuilder(
                                      future: initializedFuturePlay,
                                      builder: (context, snapshot) {
                                        // if (snapshot.connectionState ==
                                        //     ConnectionState.done) {
                                        return Visibility(
                                          child: AspectRatio(
                                            aspectRatio: 9 / 16,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: post.mediaData.length,
                                              itemBuilder: (context, i) {
                                                VideoPlayerController?
                                                    videoPlayerController;
                                                videoPlayerController =
                                                    VideoPlayerController
                                                        .network(
                                                  post.mediaData.first.type ==
                                                          "Video"
                                                      ? post.mediaData[i].link
                                                          .toString()
                                                      : "",
                                                );

                                                return InkWell(
                                                  onTap: () => Get.to(() =>
                                                      PostDetailScreen(
                                                          postModel: post,
                                                          postCardController:
                                                              postCardController)),
                                                  onDoubleTap: () {
                                                    log("clicked");
                                                    postCardController
                                                            .isLiked.value =
                                                        !post.likesIds
                                                            .contains(user!.id);
                                                    postCardController
                                                        .likeDisLikePost(
                                                            user!.id,
                                                            post.id,
                                                            post.creatorId);
                                                  },
                                                  child: AspectRatio(
                                                    aspectRatio: 9 / 16,
                                                    child: Stack(
                                                      children: [
                                                        VideoPlayerWidget(
                                                          videoPlayerController:
                                                              videoPlayerController,
                                                          videoUrl: post
                                                              .mediaData[i]
                                                              .link,
                                                        ),
                                                        Positioned(
                                                          top: 12,
                                                          left: 0,
                                                          right: 0,
                                                          child:
                                                              CustomPostHeader(
                                                            isVerified: post
                                                                .creatorDetails
                                                                .isVerified,
                                                            time: timeago.format(
                                                                DateTime.parse(post
                                                                    .createdAt)),
                                                            name: post
                                                                .creatorDetails
                                                                .name,
                                                            image: post
                                                                .creatorDetails
                                                                .imageUrl,
                                                            headerOnTap: () {
                                                              postCardController
                                                                  .gotoAppUserScreen(
                                                                      post.creatorId);
                                                            },
                                                            isVideoPost: true,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                        // }
                                        // else {
                                        //   return const CircularProgressIndicator();
                                        // }
                                      }),
                                ),
                                Visibility(
                                  visible: post.mediaData[0].type == "Qoute",
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 229,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: post.mediaData.length,
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                            onTap: () => Get.to(() =>
                                                PostDetailScreen(
                                                    postModel: post,
                                                    postCardController:
                                                        postCardController)),
                                            onDoubleTap: () {
                                              log("clicked");
                                              postCardController.isLiked.value =
                                                  !post.likesIds
                                                      .contains(user!.id);
                                              postCardController
                                                  .likeDisLikePost(user!.id,
                                                      post.id, post.creatorId);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 40,
                                                vertical: 50,
                                              ),
                                              decoration: const BoxDecoration(
                                                  color: Colors.white),
                                              child: Center(
                                                child: Text(
                                                  post.mediaData[index].link,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: color221,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                heightBox(10.h),
                                CustomPostFooter(
                                  likes: post.likesIds.length.toString(),
                                  isLike: post.likesIds.contains(user!.id),

                                  ontapLike: () {
                                    log("clicked");
                                    postCardController.isLiked.value =
                                        !post.likesIds.contains(user!.id);
                                    postCardController.likeDisLikePost(
                                        user!.id, post.id, post.creatorId);
                                  },
                                  // ontapSave: () {
                                  //   log(user!.savedPostsIds);

                                  // },
                                  saveBtn: StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var userData = snapshot.data!.data();
                                        var userModel =
                                            UserModel.fromMap(userData!);
                                        return IconButton(
                                          onPressed: () {
                                            if (userModel.savedPostsIds
                                                .contains(post.id)) {
                                              FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(userModel.id)
                                                  .update({
                                                'savedPostsIds':
                                                    FieldValue.arrayRemove(
                                                        [post.id])
                                              });
                                            } else if (!snapshot.hasData) {
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else {
                                              FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(userModel.id)
                                                  .update({
                                                'savedPostsIds':
                                                    FieldValue.arrayUnion(
                                                        [post.id])
                                              });
                                            }
                                          },
                                          icon: Image.asset(
                                            postSave,
                                            color: userModel.savedPostsIds
                                                    .contains(post.id)
                                                ? colorPrimaryA05
                                                : null,
                                          ),
                                        );
                                      } else {
                                        return Image.asset(postSave);
                                      }
                                    },
                                  ),
                                  postId: post.id,
                                  ontapShare: () {
                                    Get.to(() => SharePostScreen(
                                          postModel: PostModel(
                                            id: post.id,
                                            creatorId: post.creatorId,
                                            creatorDetails: post.creatorDetails,
                                            createdAt: post.createdAt,
                                            description: post.description,
                                            locationName: post.locationName,
                                            shareLink: post.shareLink,
                                            mediaData: post.mediaData,
                                            tagsIds: post.tagsIds,
                                            likesIds: post.likesIds,
                                            showPostTime: post.showPostTime,
                                            postBlockStatus:
                                                post.postBlockStatus,
                                            commentIds: post.commentIds,
                                          ),
                                        ));
                                  },
                                  ontapCmnt: () {
                                    // Get.to(() => CommentScreen(
                                    //       id: post.id,
                                    //       creatorId: post.creatorId,
                                    //       comment: post.commentIds,
                                    //       creatorDetails: CreatorDetails(
                                    //           name: post.creatorDetails.name,
                                    //           imageUrl:
                                    //               post.creatorDetails.imageUrl,
                                    //           isVerified: post
                                    //               .creatorDetails.isVerified),
                                    //     ));
                                    Get.to(() => PostDetailScreen(
                                        postModel: post,
                                        postCardController:
                                            postCardController));
                                  },
                                  comments: post.commentIds.length,
                                  isDesc: post.description.isNotEmpty,
                                  desc: post.description.toString(),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
        ],
      ),
    );
  }
}

class BottomSheetWidget extends StatelessWidget {
  BottomSheetWidget({Key? key, this.ontapBlock}) : super(key: key);

  final List reportList = [
    "It's a spam",
    "Nudity or sexual activity",
    "I just don't like it",
    "Scam or fraud",
    "False Information",
    "Hate speech or symbols",
  ];

  final VoidCallback? ontapBlock;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(icBottomSheetScroller),
          ),
          heightBox(12.h),
          TextButton(
            onPressed: () {
              Get.back();
              Get.bottomSheet(Container(
                height: 425.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(icBottomSheetScroller),
                    ),
                    heightBox(12.h),
                    TextWidget(
                        text:
                            """Are you sure you wanted to report this post if yes then choose the reason for the report which is the related to the post""",
                        textAlign: TextAlign.center,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.6)),
                    ListView.builder(
                        itemCount: reportList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Get.back();

                              Get.bottomSheet(Container(
                                height: 280.h,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(icBottomSheetScroller),
                                    heightBox(15.h),
                                    SvgPicture.asset(icReportPostDone),
                                    heightBox(15.h),
                                    TextWidget(
                                      text: "Thank you for the Report Us",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.sp,
                                      color: const Color(0xff212121),
                                    ),
                                    heightBox(12.h),
                                    TextWidget(
                                      text: "We have sparm the report",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: const Color(0xff5f5f5f),
                                    ),
                                  ],
                                ),
                              ));
                            },
                            title: TextWidget(
                              textAlign: TextAlign.left,
                              text: reportList[index],
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                  ],
                ),
              ));
            },
            child: TextWidget(
              text: "Report Post",
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: ontapBlock,
            child: TextWidget(
              text: "Block User",
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

class CustomPostHeader extends StatelessWidget {
  final String? name;
  final String? image;
  final VoidCallback? ontap;
  final VoidCallback? headerOnTap;
  final bool? isVerified;
  final String? time;
  final bool? isVideoPost;
  final VoidCallback? onVertItemClick;

  const CustomPostHeader(
      {Key? key,
      this.name,
      this.image,
      this.ontap,
      this.isVideoPost = false,
      this.headerOnTap,
      this.isVerified = false,
      this.onVertItemClick,
      this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(vertical: -2),
      horizontalTitleGap: 10,
      leading: InkWell(
        onTap: headerOnTap,
        child: Container(
          height: 40.h,
          width: 40.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber,
            image: DecorationImage(
              image: NetworkImage("$image"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: InkWell(
        onTap: headerOnTap,
        child: Row(
          children: [
            TextWidget(
              text: "$name",
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isVideoPost! ? colorFF7 : color221,
            ),
            widthBox(5.w),
            Visibility(
              visible: isVerified!,
              child: SvgPicture.asset(
                icVerifyBadge,
                width: 17.w,
                height: 17.h,
              ),
            )
          ],
        ),
      ),
      subtitle: TextWidget(
        text: time,
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color:
            isVideoPost! ? colorFF7.withOpacity(0.6) : const Color(0xff5f5f5f),
      ),
      trailing: InkWell(
        onTap: onVertItemClick,
        child: Icon(
          Icons.more_vert,
          color: isVideoPost! ? colorFF7 : const Color(0xffafafaf),
        ),
      ),
    );
  }
}

class CustomPostFooter extends StatelessWidget {
  final bool? isLike;
  final String? likes;
  final int? comments;
  final String? desc;
  final VoidCallback? ontapLike;
  final VoidCallback? ontapCmnt;
  final VoidCallback? ontapShare;
  final Widget? saveBtn;
  final String? postId;
  final bool? isDesc;
  final bool? isPostDetail;

  const CustomPostFooter({
    Key? key,
    this.likes,
    this.comments,
    this.ontapLike,
    this.ontapCmnt,
    this.ontapShare,
    this.isDesc = false,
    this.desc,
    this.isLike = false,
    this.isPostDetail = false,
    this.saveBtn,
    this.postId,
  }) : super(key: key);

  // final postController = PostCardController(postdata: postdata);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                widthBox(5.w),
                IconButton(
                  onPressed: ontapLike,
                  icon: AssetImageWidget(
                    imageName: isLike! ? postLikeRed : postLike,
                    // height: 13,
                  ),
                ),
                Text("$likes"),
                IconButton(
                  onPressed: ontapCmnt,
                  icon: const AssetImageWidget(
                    imageName: postComment,
                  ),
                ),
                Text("$comments"),
                IconButton(
                  onPressed: ontapShare,
                  icon: const AssetImageWidget(
                    imageName: postSend,
                  ),
                ),
              ],
            ),
            saveBtn!,
          ],
        ),
        Visibility(
          visible: isDesc!,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              child: Text(
                "$desc",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: color13F,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: isPostDetail!
              ? false
              : comments != null
                  ? comments! > 0
                  : false,
          child: Align(
            alignment: Alignment.centerLeft,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(postId)
                  .collection("comments")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs.first.data();
                  // var cDetail =
                  //     CreatorDetails.fromMap(data['creatorDetails']);
                  var cmnt = Comment.fromMap(data);
                  return ListTile(
                    horizontalTitleGap: 10,
                    onTap: ontapCmnt,
                    leading: InkWell(
                      onTap: () {
                        Get.to(
                          () => AppUserScreen(
                            appUserController: Get.put(
                              AppUserController(
                                appUserId: cmnt.creatorId,
                                currentUserId:
                                    FirebaseAuth.instance.currentUser!.uid,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.h,
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
                    ),
                    title: Row(
                      children: [
                        TextWidget(
                            text: cmnt.creatorDetails.name,
                            fontSize: 14.sp,
                            color: const Color(0xff212121),
                            fontWeight: FontWeight.w600),
                        widthBox(4.w),
                        if (cmnt.creatorDetails.isVerified)
                          SvgPicture.asset(icVerifyBadge),
                        widthBox(8.w),
                        Text(
                          timeago.format(
                            DateTime.parse(
                              cmnt.createdAt,
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff5c5c5c)),
                        ),
                      ],
                    ),
                    subtitle: TextWidget(
                      text: cmnt.message.isEmpty ? "---" : cmnt.message,
                      fontSize: 12.sp,
                      color: const Color(0xff5f5f5f),
                      fontWeight: FontWeight.w400,
                      textOverflow: TextOverflow.visible,
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ShowAllPosts(
//                     query: homeScreenController.postQuerry,
//                     physics:  BouncingScrollPhysics(
//                         parent: AlwaysScrollableScrollPhysics()),
//                   ),

// class ShowAllPosts extends StatefulWidget {
//    ShowAllPosts({
//     Key? key,
//     required this.query,
//     this.physics,
//     this.shrinkWrap = false,
//   }) : super(key: key);

//   final Query<Map<String, dynamic>> query;
//   final ScrollPhysics? physics;
//   final bool shrinkWrap;

//   @override
//   State<ShowAllPosts> createState() => _ShowAllPostsState();
// }

// class _ShowAllPostsState extends State<ShowAllPosts> {
//   late ScrollController _scrollController;
//   @override
//   void setState(VoidCallback fn) {
//     if (mounted) {
//       super.setState(fn);
//     }
//   }

//   @override
//   void initState() {
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       setState(() {});
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   VideoPlayerController? currentVideoController;
//   @override
//   Widget build(BuildContext context) {
//     return CustomeFirestoreListView(
//       shrinkWrap: widget.shrinkWrap,
//       physics: widget.physics,
//       query: widget.query,
//       addAutomaticKeepAlives: true,
//       itemBuilder: (context, QueryDocumentSnapshot<Map<String, dynamic>> doc) {
//         final post = PostModel.fromMap(doc.data());

//         if ((post.reportCount ?? 0) <= 10 &&
//             (post.postBlockStatus != "Blocked")) {
//           final postCardController = Get.put(
//             PostCardController(postdata: post),
//             tag: post.id,
//           );

// return NewPostCard(
//               z);
//         }
//         return  SizedBox(height: 0, width: 0);
//       },
//     );
//   }
// }

// class ShowAllStory extends StatefulWidget {
//    ShowAllStory({Key? key}) : super(key: key);

//   @override
//   State<ShowAllStory> createState() => _ShowAllStoryState();
// }

// class _ShowAllStoryState extends State<ShowAllStory> {
//   List<Story> list = [];
//   StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? listner;
//   @override
//   void initState() {
//     listner = FirebaseFirestore.instance
//         .collection('stories')
//         .where('createdAt',
//             isLessThan: DateTime.now().toIso8601String(),
//             isGreaterThan: DateTime.now()
//                 .subtract( Duration(days: 1))
//                 .toIso8601String())
//         .snapshots()
//         .listen((storiesSnapshot) async {
//       for (var element in storiesSnapshot.docs) {
//         Story story = Story.fromMap(element.data());
//         DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
//             await FirebaseFirestore.instance
//                 .collection("users")
//                 .doc(story.creatorId)
//                 .get();
//         story.creatorDetails.isVerified =
//             documentSnapshot.data()?['isVerified'] ?? false;
//         int index = list.indexWhere((element) => element.id == story.id);
//         if (index != -1) {
//           list[index] = story;
//         } else {
//           list.add(story);
//         }
//         setState(() {});
//       }
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     listner?.pause();
//     listner?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: list.length,
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: 5.w),
//             child: GestureDetector(
//               onTap: () {
//                 Get.to(
//                   () => StoryViewScreen(
//                     story: list[index],
//                   ),
//                 );
//               },
//               child: Container(
//                   decoration: BoxDecoration(
//                       border: Border.all(color: colorPrimaryA05, width: 1.5),
//                       shape: BoxShape.circle),
//                   height: 90.h,
//                   width: 90.h,
//                   alignment: Alignment.center,
//                   child: AspectRatio(
//                       aspectRatio: 1 / 1,
//                       child: ClipOval(
//                           child: FadeInImage(
//                               fit: BoxFit.cover,
//                               placeholder:  AssetImage(imgUserPlaceHolder),
//                               image: NetworkImage(
//                                   list[index].creatorDetails.imageUrl))))),
//             ),
//           );
//         });
//   }
// }
