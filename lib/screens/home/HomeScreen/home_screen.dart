import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_chat_screen.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/screens/home/HomeScreen/home_screen_controller.dart';
import 'package:casarancha/screens/home/CreateStory/add_story_screen.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_controller.dart';
import 'package:casarancha/widgets/PostCard/postCard.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';
import 'package:casarancha/widgets/asset_image_widget.dart';
import 'package:casarancha/widgets/custome_firebase_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../resources/image_resources.dart';
import '../../../resources/localization_text_strings.dart';
import '../../../widgets/common_widgets.dart';
import '../CreatePost/create_post_screen.dart';
import '../notification_screen.dart';
import '../story_view_screen.dart';

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
            icon: SvgPicture.asset(
              icNotifyBell,
            ),
          ),
        ],
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10.w),
          SizedBox(
            height: 70.h,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: StreamBuilder<DocumentSnapshot<Map>>(
                      stream: FirebaseFirestore.instance
                          .collection("stories")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data!.data());
                          var data = snapshot.data!.data();
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => AddStoryScreen());
                                },
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      minRadius: 25,
                                      backgroundImage: NetworkImage(
                                          data!["creatorDetails"]['imageUrl']),
                                    ),
                                    Positioned(
                                        right: -2,
                                        bottom: -2,
                                        child: Container(
                                            padding: const EdgeInsets.all(2.0),
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 18,
                                            )))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                "Your Story",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 10),
                              )
                            ],
                          );
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
                        }
                      }),
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("stories")
                      .where("creatorId",
                          isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      // .where('createdAt',

                      // isLessThan: DateTime.now().toIso8601String(),
                      // isGreaterThan: DateTime.now()
                      //     .subtract(const Duration(days: 1))
                      //     .toIso8601String())
                      .snapshots(),
                  builder: (context, snapshot) {
                    print("+++++++++++++++++++${snapshot.data}");
                    if (snapshot.hasData && snapshot.data != null) {
                      final data = snapshot.data!.docs;
                      // double progress =
                      // data.bytesTransferred / data.totalBytes;
                      print("++++++++++++++++++++++++++++- $data");
                      return Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var storyData = data[index].data();
                              Story story = Story.fromMap(storyData);
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => StoryViewScreen(story: story),
                                        );
                                      },
                                      child: CircleAvatar(
                                        minRadius: 25,
                                        backgroundImage: NetworkImage(
                                            story.creatorDetails.imageUrl),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      getFirstName(story.creatorDetails.name),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              );
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
                ),
              ],
            ),
          ),
          SizedBox(height: 10.w),
          homeScreenController.profileScreenController.isGhostModeOn.value
              ? Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Please deactivate ghost mode to \nreturn to the home page",
                    textAlign: TextAlign.center,
                  ),
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: homeScreenController.postQuerry.snapshots(),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      var data = snap.data!.docs;
                      VideoPlayerController? videoPlayerController;
                      print("In here _++++++++++____++++");
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
                          AppUserController? appUserController;

                          videoPlayerController = VideoPlayerController.network(
                              post.mediaData.first.type == "Video"
                                  ? post.mediaData[0].link.toString()
                                  : "");
                          videoPlayerController!.initialize();

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
                                                  onDoubleTap: () {
                                                    print("clicked");
                                                    postCardController
                                                            .isLiked.value =
                                                        !post.likesIds
                                                            .contains(user!.id);
                                                    postCardController
                                                        .likeDisLikePost(
                                                            user!.id, post.id);
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
                                  child: Column(
                                    children: [
                                      InkWell(
                                        // onTap: () {
                                        //   if (videoPlayerController!
                                        //       .value.isPlaying) {
                                        //     videoPlayerController!.pause();
                                        //   } else {
                                        //     videoPlayerController!.play();
                                        //   }
                                        // },s
                                        onDoubleTap: () {
                                          print("clicked");
                                          postCardController.isLiked.value =
                                              !post.likesIds.contains(user!.id);
                                          postCardController.likeDisLikePost(
                                              user!.id, post.id);
                                        },
                                        child: AspectRatio(
                                          aspectRatio: 2 / 3,
                                          child: Stack(
                                            children: [
                                              videoPlayerController != null
                                                  ? VideoPlayer(
                                                      videoPlayerController!)
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                              Positioned(
                                                top: 12,
                                                left: 0,
                                                right: 0,
                                                child: CustomPostHeader(
                                                  name:
                                                      post.creatorDetails.name,
                                                  image: post
                                                      .creatorDetails.imageUrl,
                                                  ontap: () {},
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
                                      ),
                                      heightBox(12.h),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: post.mediaData[0].type == "Qoute",
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomPostHeader(
                                          name: post.creatorDetails.name,
                                          image: post.creatorDetails.imageUrl,
                                          ontap: () {},
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
                                            onDoubleTap: () {
                                              print("clicked");
                                              postCardController.isLiked.value =
                                                  !post.likesIds
                                                      .contains(user!.id);
                                              postCardController
                                                  .likeDisLikePost(
                                                      user!.id, post.id);
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
                                    print("clicked");
                                    postCardController.isLiked.value =
                                        !post.likesIds.contains(user!.id);
                                    postCardController.likeDisLikePost(
                                        user!.id, post.id);
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

class CustomPostHeader extends StatelessWidget {
  final String? name;
  final String? image;
  final VoidCallback? ontap;
  final VoidCallback? headerOnTap;

  final bool? isVideoPost;

  const CustomPostHeader(
      {Key? key,
      this.name,
      this.image,
      this.ontap,
      this.isVideoPost = false,
      this.headerOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: headerOnTap,
          child: Row(
            children: [
              widthBox(12.w),
              Container(
                height: 30.h,
                width: 30.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                  image: DecorationImage(
                    image: NetworkImage("$image"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              widthBox(15.w),
              Text(
                "$name",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isVideoPost! ? colorFF7 : color221),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: ontap,
          icon: Icon(
            Icons.more_vert,
            color: isVideoPost! ? colorFF7 : color221,
          ),
        )
      ],
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
  final VoidCallback? ontapSave;
  final bool? isDesc;

  const CustomPostFooter({
    Key? key,
    this.likes,
    this.comments,
    this.ontapLike,
    this.ontapCmnt,
    this.ontapShare,
    this.ontapSave,
    this.isDesc = false,
    this.desc,
    this.isLike = false,
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
                widthBox(12.w),
                InkWell(
                  onTap: ontapLike,
                  child: AssetImageWidget(
                    imageName: isLike! ? postLikeRed : postLike,
                    // height: 13,
                  ),
                ),
                widthBox(12.w),
                Text("$likes"),
                widthBox(12.w),
                const AssetImageWidget(
                  imageName: postComment,
                ),
                widthBox(12.w),
                Text("$comments"),
                widthBox(12.w),
                const AssetImageWidget(
                  imageName: postSend,
                ),
              ],
            ),
            Row(
              children: [
                const AssetImageWidget(
                  imageName: postSave,
                ),
                widthBox(16.w),
              ],
            ),
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
          visible: comments != null ? comments! > 0 : false,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: InkWell(
                onTap: ontapCmnt,
                child: Text(
                  "show all $comments comments",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: color080,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ShowAllPosts(
//                     query: homeScreenController.postQuerry,
//                     physics: const BouncingScrollPhysics(
//                         parent: AlwaysScrollableScrollPhysics()),
//                   ),

class ShowAllPosts extends StatefulWidget {
  const ShowAllPosts({
    Key? key,
    required this.query,
    this.physics,
    this.shrinkWrap = false,
  }) : super(key: key);

  final Query<Map<String, dynamic>> query;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  State<ShowAllPosts> createState() => _ShowAllPostsState();
}

class _ShowAllPostsState extends State<ShowAllPosts> {
  late ScrollController _scrollController;
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  VideoPlayerController? currentVideoController;
  @override
  Widget build(BuildContext context) {
    return CustomeFirestoreListView(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      query: widget.query,
      addAutomaticKeepAlives: true,
      itemBuilder: (context, QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        final post = PostModel.fromMap(doc.data());

        if ((post.reportCount ?? 0) <= 10 &&
            (post.postBlockStatus != "Blocked")) {
          final postCardController = Get.put(
            PostCardController(postdata: post),
            tag: post.id,
          );

          return NewPostCard(
              postCardController: postCardController,
              videoPlayerController: currentVideoController);
        }
        return const SizedBox(height: 0, width: 0);
      },
    );
  }
}

// class ShowAllStory extends StatefulWidget {
//   const ShowAllStory({Key? key}) : super(key: key);

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
//                 .subtract(const Duration(days: 1))
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
//                               placeholder: const AssetImage(imgUserPlaceHolder),
//                               image: NetworkImage(
//                                   list[index].creatorDetails.imageUrl))))),
//             ),
//           );
//         });
//   }
// }
