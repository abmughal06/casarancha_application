import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/dashboard/ghost_mode_btn.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/profle_screen_widgets/image_grid.dart';
import '../../../widgets/profle_screen_widgets/music_grid.dart';
import '../../../widgets/profle_screen_widgets/profile_menu.dart';
import '../../../widgets/profle_screen_widgets/profile_top_loader.dart';
import '../../../widgets/profle_screen_widgets/qoutes_grid.dart';

import '../../../widgets/profle_screen_widgets/video_grid.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final user = context.watch<UserModel?>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const GhostModeBtn(),
          elevation: 0,
          backgroundColor: Colors.grey.shade50,
          actions: [
            IconButton(
              onPressed: () {
                bottomSheetProfile(context);
              },
              icon: Image.asset(
                imgProfileOption,
              ),
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Consumer<UserModel?>(
                builder: (context, user, b) {
                  if (user == null) {
                    return const ProfileTopLoader();
                  } else {
                    return ProfileTop(
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
                TabBar(
                  labelColor: colorPrimaryA05,
                  unselectedLabelColor: colorAA3,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                  indicatorColor: colorF03,
                  indicatorPadding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      child: TextWidget(text: appText(context).strQuote),
                    ),
                    Tab(
                      child: TextWidget(text: appText(context).strImages),
                    ),
                    Tab(
                      child: TextWidget(text: appText(context).strVideos),
                    ),
                    Tab(
                      child: TextWidget(text: appText(context).strMusic),
                    ),
                  ],
                ),
                heightBox(10.w),
                StreamProvider.value(
                  initialData: null,
                  value: DataProvider().getUserPosts(currentUserUID),
                  catchError: (context, error) => null,
                  child:
                      Consumer<List<PostModel>?>(builder: (context, post, b) {
                    if (post == null) {
                      return centerLoader();
                    }

                    return Expanded(
                      child: TabBarView(
                        children: [
                          //qoute
                          QoutesGridView(
                            qoutesList: post
                                .where((element) =>
                                    element.mediaData.first.type == 'Qoute')
                                .toList(),
                          ),
                          ImageGridView(
                            imageList: post
                                .where((element) =>
                                    element.mediaData.first.type == 'Photo')
                                .toList(),
                          ),
                          VideoGridView(
                            videoList: post
                                .where((element) =>
                                    element.mediaData.first.type == 'Video')
                                .toList(),
                          ),
                          //music
                          MusicGrid(
                            musicList: post
                                .where((element) =>
                                    element.mediaData.first.type == 'Music')
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
