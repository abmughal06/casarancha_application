import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/widgets/profle_screen_widgets/profile_top_loader.dart';
import 'package:casarancha/widgets/profle_screen_widgets/qoutes_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:provider/provider.dart';

import '../../../models/providers/user_data_provider.dart';
import '../../../models/user_model.dart';

import '../../../widgets/common_widgets.dart';
import '../../../widgets/menu_user_button.dart';
import '../../../widgets/profle_screen_widgets/image_grid.dart';
import '../../../widgets/profle_screen_widgets/music_grid.dart';
import '../../../widgets/profle_screen_widgets/video_grid.dart';
import '../../../widgets/text_widget.dart';

void navigateToAppUserScreen(userId, context) {
  if (userId != FirebaseAuth.instance.currentUser!.uid) {
    Get.to(() => AppUserScreen(appUserId: userId));
  } else {
    final dasboardController =
        Provider.of<DashboardProvider>(context, listen: false);
    dasboardController.changePage(5);
  }
}

class AppUserScreen extends StatelessWidget {
  const AppUserScreen({
    super.key,
    required this.appUserId,
  });

  final String appUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          color: Colors.black,
          icon: SvgPicture.asset(icIosBackArrow),
        ),
        actions: [
          menuUserButton(
            context,
            appUserId,
            "",
          ),
          widthBox(15.w),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                StreamProvider.value(
                  value: DataProvider().getSingleUser(appUserId),
                  initialData: null,
                  catchError: (context, error) => null,
                  child: Consumer<UserModel?>(
                    builder: (context, user, b) {
                      if (user == null) {
                        return const ProfileTopLoader();
                      } else {
                        return ProfileTop(user: user);
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
        body: DefaultTabController(
          length: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                value: DataProvider().getUserPosts(appUserId),
                catchError: (context, error) => null,
                child: Consumer<List<PostModel>?>(builder: (context, post, b) {
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
    );
  }
}
