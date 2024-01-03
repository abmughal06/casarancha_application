import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../resources/image_resources.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_widget.dart';
import '../search/search_screen.dart';

class SharePostScreen extends StatefulWidget {
  const SharePostScreen({super.key, required this.postModel, this.groupId});
  final PostModel postModel;
  final String? groupId;

  @override
  State<SharePostScreen> createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {
  late PostProvider postProvider;

  @override
  void dispose() {
    super.dispose();

    postProvider.restoreReciverList();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    postProvider = Provider.of<PostProvider>(context);
    final search = Provider.of<SearchProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100.h,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 65.h),
                    child: TextWidget(
                      text: "Share Post",
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: 20.w,
                  top: 65.h,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      size: 20.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: searchTextField(
              context: context,
              controller: searchController,
              onChange: (value) {
                search.searchText(value);
              },
            ),
          ),
          Consumer<List<UserModel>?>(
            builder: (context, users, b) {
              if (users == null) {
                return Container();
              } else {
                var currentUser = users
                    .where((element) => element.id == currentUserUID)
                    .first;
                var filterList = users
                    .where((element) =>
                        currentUser.followersIds.contains(element.id) ||
                        currentUser.followingsIds.contains(element.id))
                    .toList();

                var appUsers = users
                    .where((element) =>
                        element.id != currentUserUID &&
                        !currentUser.followersIds.contains(element.id) &&
                        !currentUser.followingsIds.contains(element.id))
                    .toList();

                var newList = filterList + appUsers;

                if (searchController.text.isEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 120.h),
                      itemCount: newList.length,
                      itemBuilder: (context, index) {
                        return SharePostTile(
                          appUser: newList[index],
                          postModel: widget.postModel,
                          currentUser: currentUser,
                          isSent: postProvider.recieverIds
                              .contains(newList[index].id),
                          ontapSend: () {
                            postProvider.sharePostData(
                              currentUser: currentUser,
                              groupId: widget.groupId,
                              appUser: newList[index],
                              postModel: widget.postModel,
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                if (searchController.text.isNotEmpty) {
                  var searchList = newList
                      .where((e) =>
                          e.name
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()) ||
                          e.username
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()))
                      .toList();
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 120.h),
                      itemCount: searchList.length,
                      itemBuilder: (context, index) {
                        return SharePostTile(
                          appUser: searchList[index],
                          postModel: widget.postModel,
                          currentUser: currentUser,
                          isSent: postProvider.recieverIds
                              .contains(searchList[index].id),
                          ontapSend: () {
                            postProvider.sharePostData(
                              currentUser: currentUser,
                              groupId: widget.groupId,
                              appUser: searchList[index],
                              postModel: widget.postModel,
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                if (newList.isEmpty) {
                  return const Center(
                    child: TextWidget(
                      text: 'No user to share the app',
                    ),
                  );
                }
                return heightBox(1);
              }
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CommonButton(
        text: 'Done',
        height: 58.w,
        verticalOutMargin: 10.w,
        horizontalOutMargin: 10.w,
        onTap: () => Get.back(),
      ),
    );
  }
}

class SharePostTile extends StatelessWidget {
  const SharePostTile({
    super.key,
    required this.postModel,
    required this.currentUser,
    required this.appUser,
    required this.isSent,
    required this.ontapSend,
  });

  final PostModel postModel;
  final UserModel currentUser;
  final UserModel appUser;
  final bool isSent;
  final VoidCallback ontapSend;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                appUser.imageStr != ''
                    ? CircleAvatar(
                        radius: 25,
                        backgroundImage: appUser.imageStr.isEmpty
                            ? null
                            : CachedNetworkImageProvider(
                                appUser.imageStr,
                              ),
                        child: appUser.imageStr.isEmpty
                            ? const Icon(
                                Icons.question_mark,
                              )
                            : null,
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 25,
                        backgroundImage: AssetImage(imgUserPlaceHolder),
                      ),
                widthBox(12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: appUser.username,
                      color: color221,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    heightBox(3.h),
                    TextWidget(
                      text: appUser.name,
                      color: colorAA3,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: isSent
                    ? colorPrimaryA05.withOpacity(0.16)
                    : colorPrimaryA05,
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: ontapSend,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                  child: TextWidget(
                    text: isSent ? "Sent" : "Send",
                    letterSpacing: 0.7,
                    color: isSent ? colorPrimaryA05 : colorFF3,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
