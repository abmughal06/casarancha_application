import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/widgets/primary_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../widgets/common_widgets.dart';
import '../../../widgets/profle_screen_widgets/image_grid.dart';
import '../../../widgets/profle_screen_widgets/music_grid.dart';
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
                      child: Text('Musics'),
                    ),
                  ],
                ),
                heightBox(10.w),
                Expanded(
                  child: TabBarView(
                    children: [
                      //qoute
                      post == null
                          ? const Center(
                              child: CircularProgressIndicator.adaptive())
                          : QoutesGridView(
                              qoutesList: post
                                  .where((element) =>
                                      element.creatorId == user!.id &&
                                      element.mediaData.first.type == 'Qoute')
                                  .toList(),
                            ),
                      post == null
                          ? const Center(
                              child: CircularProgressIndicator.adaptive())
                          : ImageGridView(
                              imageList: post
                                  .where((element) =>
                                      element.creatorId == user!.id &&
                                      element.mediaData.first.type == 'Photo')
                                  .toList(),
                            ),
                      post == null
                          ? const Center(
                              child: CircularProgressIndicator.adaptive())
                          : VideoGridView(
                              videoList: post
                                  .where((element) =>
                                      element.creatorId == user!.id &&
                                      element.mediaData.first.type == 'Video')
                                  .toList(),
                            ),
                      //music
                      post == null
                          ? const Center(
                              child: CircularProgressIndicator.adaptive())
                          : MusicGrid(
                              musicList: post
                                  .where((element) =>
                                      element.creatorId == user!.id &&
                                      element.mediaData.first.type == 'Music')
                                  .toList(),
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
