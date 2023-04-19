import 'dart:async';

import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/screens/dashboard/dashboard_controller.dart';
import 'package:casarancha/screens/home/HomeScreen/home_screen_controller.dart';
import 'package:casarancha/screens/home/CreateStory/add_story_screen.dart';
import 'package:casarancha/screens/home/story_view_screen.dart';

import 'package:casarancha/widgets/PostCard/postCard.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';
import 'package:casarancha/widgets/asset_image_widget.dart';
import 'package:casarancha/widgets/custome_firebase_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeScreenController = Get.put(HomeScreenController());

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
        elevation: 3,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10.w),
          if (Get.find<DashboardController>().isShowStoryBtn.value)
            SizedBox(
              height: 50.h,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => AddStoryScreen());
                      },
                      child: SvgPicture.asset(
                        icProfileAdd,
                        height: 50.h,
                        width: 50.w,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: ShowAllStory(),
                  ),
                ],
              ),
            ),
          SizedBox(height: 10.w),
          Expanded(
            child: homeScreenController
                    .profileScreenController.isGhostModeOn.value
                ? Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Please deactivate ghost mode to \nreturn to the home page",
                      textAlign: TextAlign.center,
                    ),
                  ) /* ListViewPostsWithWhereInQuerry(
                        listOfIds: homeScreenController
                            .profileScreenController.user.value.followingsIds,
                        field: 'creatorId',
                        controllerTag: 'Ghost Mode Home',
                      ) */
                : StreamBuilder<QuerySnapshot>(
                    stream: homeScreenController.postQuerry.snapshots(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        var data = snap.data!.docs;
                        VideoPlayerController? videoPlayerController;

                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final prePost =
                                data[index].data() as Map<String, dynamic>;
                            final post = PostModel.fromMap(prePost);
                            PostCardController postCardController =
                                PostCardController(postdata: post);
                            // final post = postCardController.post.value;

                            videoPlayerController =
                                VideoPlayerController.network(
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
                                          ontap: () {},
                                        ),
                                        heightBox(10.h),
                                        Image.network(post.mediaData[0].link),
                                        heightBox(10.h),
                                        CustomPostFooter(
                                          likes:
                                              post.likesIds.length.toString(),
                                          comments:
                                              post.commentIds.length.toString(),
                                          isDesc: post.description.isNotEmpty,
                                          desc: post.description.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: post.mediaData[0].type == "Video",
                                    child: Column(
                                      children: [
                                        AspectRatio(
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
                                                  isVideoPost: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        heightBox(12.h),
                                        CustomPostFooter(
                                          likes:
                                              post.likesIds.length.toString(),
                                          ontapLike: () {},
                                          comments:
                                              post.commentIds.length.toString(),
                                          isDesc: post.description.isNotEmpty,
                                          desc: post.description.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: post.mediaData[0].type == "Qoute",
                                    child: SizedBox(
                                      height: 229,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomPostHeader(
                                            name: post.creatorDetails.name,
                                            image: post.creatorDetails.imageUrl,
                                            ontap: () {},
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20.h,
                                                horizontal: 50.w),
                                            child: Text(
                                              post.mediaData[0].link,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                color: color221,
                                              ),
                                            ),
                                          ),
                                          CustomPostFooter(
                                            likes:
                                                post.likesIds.length.toString(),
                                            isLike: post.likesIds
                                                .contains(post.creatorId),
                                            ontapLike: () {
                                              print("clicked");
                                              postCardController.isLiked.value =
                                                  !post.likesIds
                                                      .contains(post.creatorId);
                                              postCardController
                                                  .likeDisLikePost(
                                                      post.creatorId, post.id);
                                            },
                                            comments: post.commentIds.length
                                                .toString(),
                                            isDesc: post.description.isNotEmpty,
                                            desc: post.description.toString(),
                                          ),
                                        ],
                                      ),
                                    ),
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
  final bool? isVideoPost;

  const CustomPostHeader(
      {Key? key, this.name, this.image, this.ontap, this.isVideoPost = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
  final String? comments;
  final String? desc;
  final VoidCallback? ontapLike;
  final VoidCallback? ontapCmnt;
  final VoidCallback? ontapShare;
  final VoidCallback? ontapSave;
  final bool? isDesc;

  const CustomPostFooter(
      {Key? key,
      this.likes,
      this.comments,
      this.ontapLike,
      this.ontapCmnt,
      this.ontapShare,
      this.ontapSave,
      this.isDesc = false,
      this.desc,
      this.isLike = false})
      : super(key: key);

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
        )
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

class ShowAllStory extends StatefulWidget {
  const ShowAllStory({Key? key}) : super(key: key);

  @override
  State<ShowAllStory> createState() => _ShowAllStoryState();
}

class _ShowAllStoryState extends State<ShowAllStory> {
  List<Story> list = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? listner;
  @override
  void initState() {
    listner = FirebaseFirestore.instance
        .collection('stories')
        .where('createdAt',
            isLessThan: DateTime.now().toIso8601String(),
            isGreaterThan: DateTime.now()
                .subtract(const Duration(days: 1))
                .toIso8601String())
        .snapshots()
        .listen((storiesSnapshot) async {
      for (var element in storiesSnapshot.docs) {
        Story story = Story.fromMap(element.data());
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(story.creatorId)
                .get();
        story.creatorDetails.isVerified =
            documentSnapshot.data()?['isVerified'] ?? false;
        int index = list.indexWhere((element) => element.id == story.id);
        if (index != -1) {
          list[index] = story;
        } else {
          list.add(story);
        }
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    listner?.pause();
    listner?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => StoryViewScreen(
                    story: list[index],
                  ),
                );
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: colorPrimaryA05, width: 1.5),
                      shape: BoxShape.circle),
                  height: 90.h,
                  width: 90.h,
                  alignment: Alignment.center,
                  child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipOval(
                          child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: const AssetImage(imgUserPlaceHolder),
                              image: NetworkImage(
                                  list[index].creatorDetails.imageUrl))))),
            ),
          );
        });
  }
}
