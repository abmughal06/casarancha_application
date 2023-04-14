import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/user_model.dart';

import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/widgets/PostCard/PostCard.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';
import 'package:casarancha/widgets/app_user_tile.dart';
import 'package:casarancha/widgets/custome_firebase_list_view.dart';
import 'package:casarancha/widgets/group_tile.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/common_widgets.dart';
import '../dashboard/dashboard.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Widget> _myTabs = const [
    Tab(text: 'People'),
    Tab(text: 'Groups'),
    Tab(text: 'Location'),
  ];

  late TextEditingController searchController;
  late ProfileScreenController profilescreenController;

  @override
  void initState() {
    searchController = TextEditingController();
    profilescreenController = Get.find<ProfileScreenController>();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(
        title: 'Search',
        elevation: 0,
        leading: ghostModeBtn(),
      ),
      body: DefaultTabController(
        length: _myTabs.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: searchTextField(
                context: context,
                controller: searchController,
                onChange: (value) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: commonTabBar(tabsList: _myTabs),
            ),
            heightBox(10.w),
            Expanded(
              child: TabBarView(
                children: [
                  /*people*/

                  FirestoreListView(
                    query: FirebaseFirestore.instance.collection('users').where(
                        'username',
                        isEqualTo: searchController.text.trim()),
                    padding: EdgeInsets.symmetric(
                      vertical: 10.w,
                      horizontal: 20.w,
                    ),
                    itemBuilder: (context,
                        QueryDocumentSnapshot<Map<String, dynamic>> doc) {
                      final user = UserModel.fromMap(doc.data());

                      return AppUserTile(
                        appUser: user,
                        currentUser: profilescreenController.user.value,
                      );
                    },
                  ),

                  /*group*/
                  FirestoreListView(
                    query: FirebaseFirestore.instance
                        .collection('groups')
                        .where('name', isEqualTo: searchController.text.trim()),
                    padding: EdgeInsets.symmetric(
                      vertical: 10.w,
                      horizontal: 20.w,
                    ),
                    itemBuilder: (context,
                        QueryDocumentSnapshot<Map<String, dynamic>> doc) {
                      final group = GroupModel.fromMap(doc.data());
                      return GroupTile(
                        group: group,
                        currentUserId: profilescreenController.user.value.id,
                      );
                    },
                  ),
                  ShowAllPosts(
                      query: (searchController.text.trim().isEmpty)
                          ? FirebaseFirestore.instance
                              .collection('posts')
                              .where("reportCount", isLessThanOrEqualTo: 10)
                          : FirebaseFirestore.instance
                              .collection('posts')
                              .where(
                                'locationName',
                                isEqualTo: searchController.text.trim(),
                              ))
                  /*location*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: CustomeFirestoreListView(
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        query: widget.query,
        addAutomaticKeepAlives: true,
        itemBuilder:
            (context, QueryDocumentSnapshot<Map<String, dynamic>> doc) {
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
      ),
    );
  }
}
