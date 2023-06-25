import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/firebase_cloud_messaging.dart';
import 'package:casarancha/resources/image_resources.dart';

import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';
import 'package:casarancha/widgets/custome_firebase_list_view.dart';
import 'package:casarancha/widgets/group_tile.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../models/post_creator_details.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_widget.dart';
import '../chat/GhostMode/ghost_chat_screen.dart';
import '../dashboard/dashboard.dart';
import '../profile/AppUser/app_user_controller.dart';
import '../profile/AppUser/app_user_screen.dart';

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

  bool compareStrings(String string1, String string2) {
    int matchCount = 0;

    // Loop through each character of the first string
    for (int i = 0; i < string1.length; i++) {
      // Loop through each character of the second string
      for (int j = 0; j < string2.length; j++) {
        // If the characters match, increment the match count
        if (string1[i] == string2[j]) {
          matchCount++;
        }
      }
    }
    // Return true if two or more characters match
    return matchCount >= 2;
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
                  // setState(() {});
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

                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, current) {
                        if (current.hasData) {
                          var currentUser =
                              UserModel.fromMap(current.data!.data()!);
                          return StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .orderBy("username", descending: false)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return ListView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 110),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var userSnap = UserModel.fromMap(
                                            snapshot.data!.docs[index].data());
                                        // print(userSnap);
                                        // print(
                                        //     user.name.compareTo(searchController.text));

                                        if (compareStrings(
                                                userSnap.username.toString(),
                                                searchController.text) &&
                                            userSnap.id !=
                                                FirebaseAuth.instance
                                                    .currentUser!.uid) {
                                          return InkWell(
                                            onTap: () {
                                              Get.to(
                                                () => AppUserScreen(
                                                  appUserController: Get.put(
                                                    AppUserController(
                                                      appUserId: userSnap.id,
                                                      currentUserId:
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ListTile(
                                              leading: Container(
                                                height: 50.w,
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                  color: color080,
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: NetworkImage(userSnap
                                                        .imageStr
                                                        .toString()),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              title: Row(
                                                children: [
                                                  TextWidget(
                                                    text: userSnap.name
                                                        .toString(),
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: color221,
                                                  ),
                                                  widthBox(5.w),
                                                  Visibility(
                                                    visible:
                                                        userSnap.isVerified,
                                                    child: SvgPicture.asset(
                                                      icVerifyBadge,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              subtitle: TextWidget(
                                                text: userSnap.username
                                                    .toString(),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: colorAA3,
                                              ),
                                              trailing: TextButton(
                                                child: TextWidget(
                                                  text: currentUser
                                                          .followingsIds
                                                          .contains(userSnap.id)
                                                      ? "Unfollow"
                                                      : "Follow",
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffAA0505),
                                                ),
                                                onPressed: () async {
                                                  // toggleFollow(userSnap['id']);
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(currentUser.id)
                                                      .update({
                                                    "followingsIds": currentUser
                                                            .followingsIds
                                                            .contains(
                                                                userSnap.id)
                                                        ? FieldValue
                                                            .arrayRemove(
                                                                [userSnap.id])
                                                        : FieldValue.arrayUnion(
                                                            [userSnap.id])
                                                  });
                                                  if (!currentUser.followingsIds
                                                      .contains(userSnap.id)) {
                                                    FirebaseMessagingService()
                                                        .sendNotificationToUser(
                                                      userReqID: userSnap.id,
                                                      devRegToken:
                                                          userSnap.fcmToken,
                                                      title: user!.name,
                                                      creatorDetails:
                                                          CreatorDetails(
                                                              name: user!.name,
                                                              imageUrl: user!
                                                                  .imageStr,
                                                              isVerified: user!
                                                                  .isVerified),
                                                      msg:
                                                          "has started following you",
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      });
                                } else if (snapshot.hasError ||
                                    snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return const Center(
                                      child: Text("No such user found"));
                                }
                              });
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),

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

            // return NewPostCard(
            //     postCardController: postCardController,
            //     videoPlayerController: currentVideoController);
          }
          return const SizedBox(height: 0, width: 0);
        },
      ),
    );
  }
}
