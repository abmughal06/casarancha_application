import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/screens/dashboard/dashboard_controller.dart';
import 'package:casarancha/screens/home/HomeScreen/home_screen_controller.dart';
import 'package:casarancha/screens/home/CreateStory/add_story_screen.dart';
import 'package:casarancha/screens/home/story_view_screen.dart';

import 'package:casarancha/widgets/PostCard/PostCard.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';
import 'package:casarancha/widgets/custome_firebase_list_view.dart';
import 'package:casarancha/widgets/listView_with_whereIn_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../resources/image_resources.dart';
import '../../../resources/localization_text_strings.dart';

import '../../../widgets/common_widgets.dart';

import '../CreatePost/create_post_screen.dart';
import '../notification_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
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
          SizedBox(height: 5.w),
          if (Get.find<DashboardController>().isShowStoryBtn.value)
            Container(
              height: 50.h,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 5.w),
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
                : ShowAllPosts(
                    query: homeScreenController.postQuerry,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

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
