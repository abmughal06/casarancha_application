import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/widgets/primary_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../widgets/common_widgets.dart';
import '../../../widgets/profle_screen_widgets/image_grid.dart';
import '../../../widgets/profle_screen_widgets/profile_top_loader.dart';
import '../../../widgets/profle_screen_widgets/qoutes_grid.dart';

import '../../../widgets/profle_screen_widgets/video_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel?>();
    final post = context.watch<List<PostModel>?>();

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              // child: Text(userData!.name),
              child: Consumer<UserModel?>(
                builder: (context, user, b) {
                  if (user == null) {
                    return const ProfileTopLoader();
                  } else {
                    return ProfileTop(
                      postFollowCout: post!
                          .where((element) => element.creatorId == user.id)
                          .map((e) => e)
                          .toList()
                          .length,
                      user: user,
                    );
                  }
                },
              ),
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
                      post == null
                          ? const Center(child: CircularProgressIndicator())
                          : QoutesGridView(
                              qoutesList: post
                                  .where((element) =>
                                      element.creatorId == user!.id &&
                                      element.mediaData[0].type == 'Qoute')
                                  .toList(),
                            ),
                      post == null
                          ? const Center(child: CircularProgressIndicator())
                          : ImageGridView(
                              imageList: post
                                  .where((element) =>
                                      element.creatorId == user!.id &&
                                      element.mediaData[0].type == 'Photo')
                                  .toList(),
                            ),
                      post == null
                          ? const Center(child: CircularProgressIndicator())
                          : VideoGridView(
                              videoList: post
                                  .where((element) =>
                                      element.creatorId == user!.id &&
                                      element.mediaData[0].type == 'Video')
                                  .toList(),
                            ),
                      //story
                      Container()
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

// deleteAccountFromId(User user) async {
//   String id = user.uid;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   try {
//     ProfileScreenController profileScreenController =
//         Get.put(ProfileScreenController(isFromDelete: true));
//     profileScreenController.setUserAgain();
//     GhostChatHelper.shared.gMessageCtrl.disposeStream();
//     await firestore
//         .collection("posts")
//         .where("creatorId", isEqualTo: id)
//         .get()
//         .then((value) async {
//       for (var element in value.docs) {
//         if (element.exists) {
//           await deletePost(PostModel.fromMap(element.data()));
//         }
//       }
//     });
//     await deleteStories(id);
//     await deleteUser(id);
//     FirebaseAuth.instance.signOut();
//     await deleteUserFirebase(id);
//   } catch (e) {
//     Get.back();
//     print("errors => $e");
//   }
// }

// deleteUserFirebase(String uid) async {
//   try {
//     HttpsCallable callable = FirebaseFunctions.instance
//         .httpsCallable("deleteUserFromAuthentication");
//     Map<String, dynamic> params = {
//       "data": {"uid": uid}
//     };
//     final results = (await callable.call(jsonEncode(params))).data;
//     return results;
//   } on FirebaseFunctionsException catch (e) {
//     print(e.code);
//     print(e.details);
//     throw Exception(e.message);
//   }
// }
