import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/groups/group_member_screen.dart';
import 'package:casarancha/screens/groups/group_notification_badge.dart';
import 'package:casarancha/screens/groups/group_settings.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/shared/skeleton.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/group_model.dart';
import '../../models/post_model.dart';
import '../../resources/strings.dart';
import '../../widgets/home_screen_widgets/post_card.dart';

class GroupPostScreen extends StatefulWidget {
  const GroupPostScreen({super.key, required this.group});
  final GroupModel group;

  @override
  State<GroupPostScreen> createState() => _GroupPostScreenState();
}

class _GroupPostScreenState extends State<GroupPostScreen> {
  var isScrolled = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          isScrolled(innerBoxIsScrolled);
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              stretch: true,
              elevation: 0.2,
              centerTitle: true,
              backgroundColor: Colors.grey.shade50,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${widget.group.name} ",
                      style: TextStyle(
                        color: color13F,
                        fontFamily: strFontName,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                    WidgetSpan(child: verifyBadge(widget.group.isVerified))
                  ],
                ),
              ),
              actions: [
                currentUserUID == widget.group.creatorId ||
                        widget.group.adminIds.contains(currentUserUID)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GroupNotificationBadge(
                          groupId: widget.group.id,
                          child: GestureDetector(
                            onTap: () => Get.to(() => GroupSettings(
                                  grp: widget.group,
                                )),
                            child: const Icon(
                              Icons.settings,
                              color: color887,
                            ),
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () => Get.to(() => GroupMembersScreen(
                              grp: widget.group,
                            )),
                        icon: SvgPicture.asset(icGroupMember),
                      )
              ],
            )
          ];
        },
        body: Column(
          children: [
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: isScrolled.value ? 0 : 15.h,
                ),
                height: isScrolled.value ? 0 : 43.07.h,
                decoration: BoxDecoration(
                  border: Border.all(color: colorCC8, width: 1.h),
                  borderRadius: BorderRadius.circular(60.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextWidget(
                        text: appText(context).strPostOnGrp,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: color55F,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.group.banFromPostUsersIds
                            .contains(currentUserUID)) {
                          GlobalSnackBar.show(
                              message: appText(context).strGlobalBannedGroup);
                        } else {
                          Get.to(() => CreatePostScreen(
                                groupId: widget.group.id,
                                isForum: false,
                              ));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3, right: 3),
                        child: Image.asset(
                          imgAddPost,
                          height: 35.h,
                          width: 35.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamProvider.value(
              value: DataProvider().groupPosts(widget.group.id),
              initialData: null,
              catchError: (context, error) => null,
              child: Consumer<List<PostModel>?>(
                builder: (context, posts, b) {
                  if (posts == null) {
                    return const Expanded(child: PostSkeleton());
                  }

                  if (posts.isEmpty) {
                    return Center(
                      child: TextWidget(
                        text: appText(context).strAlertGroupPost,
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 80.h),
                      cacheExtent: 10,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(
                          groupId: widget.group.id,
                          post: posts[index],
                          isGroupAdmin: widget.group.isPublic
                              ? true
                              : widget.group.creatorId == currentUserUID ||
                                  widget.group.adminIds
                                      .contains(currentUserUID),
                          postCreatorId: posts[index].creatorId,
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
