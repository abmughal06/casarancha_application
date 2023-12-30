import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/screens/groups/group_member_screen.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/widgets/common_widgets.dart';
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

class GroupPostScreen extends StatelessWidget {
  const GroupPostScreen({super.key, required this.group});
  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    // final users = context.watch<List<UserModel>?>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${group.name} ",
                style: TextStyle(
                  color: color13F,
                  fontFamily: strFontName,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              WidgetSpan(
                child: Visibility(
                  visible: group.isVerified,
                  child: SvgPicture.asset(
                    icVerifyBadge,
                    height: 17,
                  ),
                ),
              )
            ],
          ),
        ),
        elevation: 0.2,
        actions: [
          GestureDetector(
              onTap: () => Get.to(() => GroupMembersScreen(group: group)),
              child: SvgPicture.asset(icGroupMember)),
          widthBox(15.w),
        ],
      ),
      body: ListView(
        children: [
          heightBox(15.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 43.07.h,
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
                    text: strPostOnGrp,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: color55F,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => CreatePostScreen(
                          groupId: group.id,
                          isForum: false,
                        ));
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
          heightBox(15.h),
          StreamProvider.value(
            value: DataProvider().groupPosts(group.id),
            initialData: null,
            catchError: (context, error) => null,
            child: Consumer<List<PostModel>?>(
              builder: (context, posts, b) {
                if (posts == null) {
                  return Container();
                }

                // List<PostModel> filterList = [];
                // List<UserModel> postCreator = [];
                // for (var p in post) {
                //   for (var u in users) {
                //     if (p.creatorId == u.id) {
                //       filterList.add(p);
                //       postCreator.add(u);
                //     }
                //   }
                // }

                if (posts.isEmpty) {
                  return const Center(
                    child: TextWidget(
                      text: strAlertGroupPost,
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 80.h),
                  physics: const NeverScrollableScrollPhysics(),
                  addAutomaticKeepAlives: true,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      groupId: group.id,
                      post: posts[index],
                      postCreatorId: posts[index].creatorId,
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
