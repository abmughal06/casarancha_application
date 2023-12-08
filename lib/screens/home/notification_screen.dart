import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/utils/firebase_collection.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../models/post_model.dart';
import '../../resources/color_resources.dart';
import '../profile/AppUser/app_user_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void unreadNotification() async {
    var ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(cNotificationList);
    var docs = await ref.get();
    for (var d in docs.docs) {
      ref.doc(d.id).update({"isRead": true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: strNotifications, elevation: 0),
      body: DefaultTabController(
        length: 2,
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
                  EdgeInsets.symmetric(vertical: 5.h, horizontal: 35.w),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(
                  text: strNotification,
                ),
                Tab(
                  text: strRecentlyFollowedYou,
                ),
              ],
            ),
            heightBox(8.h),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Consumer<List<NotificationModel>?>(
                    builder: (context, notifications, b) {
                      if (notifications == null) {
                        return centerLoader();
                      }
                      if (notifications.isEmpty) {
                        return const Center(
                          child: TextWidget(
                            text: strAlertNotification,
                          ),
                        );
                      }
                      unreadNotification();
                      var filterList = notifications
                          .where(
                            (element) =>
                                element.notificationType != 'user_follow',
                          )
                          .toList();

                      return ListView.builder(
                        itemCount: filterList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var notification = filterList[index];

                          var isPostShow = notification.content != null
                              ? notification.content!.isNotEmpty
                                  ? true
                                  : false
                              : false;

                          PostModel? postModel =
                              notification.notificationType == 'feed_post_cmnt'
                                  ? PostModel.fromMap(notification.content)
                                  : null;

                          var contentImage =
                              notification.notificationType == 'feed_post_cmnt'
                                  ? postModel!.mediaData.first.link
                                  : notification.content;

                          return ListTile(
                            onTap: () {
                              if (notification.notificationType ==
                                  "feed_post_cmnt") {
                                Get.to(() => PostDetailScreen(
                                      postModel: postModel!,
                                      groupId: notification.groupId,
                                    ));
                              }
                              if (notification.notificationType ==
                                  'user_follow') {
                                navigateToAppUserScreen(
                                    notification.sentById, context);
                              }
                            },
                            leading: Container(
                              height: 46.h,
                              width: 46.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    notification.createdDetails!.imageUrl != ''
                                        ? colorF03
                                        : Colors.transparent,
                                image: notification
                                        .createdDetails!.imageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            notification
                                                .createdDetails!.imageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : notification.createdDetails!.imageUrl !=
                                            ''
                                        ? const DecorationImage(
                                            image: AssetImage(imgGhostUser),
                                            fit: BoxFit.cover,
                                          )
                                        : const DecorationImage(
                                            image:
                                                AssetImage(imgUserPlaceHolder),
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                            title: RichText(
                              text: TextSpan(
                                text: notification.createdDetails!.isVerified
                                    ? notification.createdDetails!.name
                                    : "${notification.createdDetails!.name} ",
                                style: TextStyle(
                                  color: const Color(0xff121F3F),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                                children: [
                                  WidgetSpan(
                                    child: Visibility(
                                      visible: notification
                                          .createdDetails!.isVerified,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child:
                                              SvgPicture.asset(icVerifyBadge)),
                                    ),
                                  ),
                                  TextSpan(
                                      text: " ${notification.msg!}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: color080,
                                      ))
                                ],
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                convertDateIntoTime(notification.createdAt!),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: const Color(0xff5F5F5F)),
                              ),
                            ),
                            trailing: Container(
                              height: isPostShow ? 50.h : 0,
                              width: isPostShow ? 40.w : 0,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: isPostShow
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            contentImage),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Consumer<List<NotificationModel>?>(
                    builder: (context, notifications, b) {
                      if (notifications == null) {
                        return centerLoader();
                      }
                      if (notifications.isEmpty) {
                        return const Center(
                          child: TextWidget(
                            text: strAlertNotification,
                          ),
                        );
                      }
                      var filterList = notifications
                          .where(
                            (element) =>
                                element.notificationType == 'user_follow',
                          )
                          .toList();
                      unreadNotification();

                      return ListView.builder(
                        itemCount: filterList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var notification = filterList[index];

                          var isPostShow = notification.content != null
                              ? notification.content!.isNotEmpty
                                  ? true
                                  : false
                              : false;

                          PostModel? postModel =
                              notification.notificationType == 'feed_post_cmnt'
                                  ? PostModel.fromMap(notification.content)
                                  : null;

                          var contentImage =
                              notification.notificationType == 'feed_post_cmnt'
                                  ? postModel!.mediaData.first.link
                                  : notification.content;

                          return ListTile(
                            onTap: () {
                              if (notification.notificationType ==
                                  "feed_post_cmnt") {
                                Get.to(() => PostDetailScreen(
                                      postModel: postModel!,
                                      groupId: notification.groupId,
                                    ));
                              }
                              if (notification.notificationType ==
                                  'user_follow') {
                                navigateToAppUserScreen(
                                    notification.sentById, context);
                              }
                            },
                            leading: Container(
                              height: 46.h,
                              width: 46.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    notification.createdDetails!.imageUrl != ''
                                        ? colorF03
                                        : Colors.transparent,
                                image: notification
                                        .createdDetails!.imageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            notification
                                                .createdDetails!.imageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : notification.createdDetails!.imageUrl !=
                                            ''
                                        ? const DecorationImage(
                                            image: AssetImage(imgGhostUser),
                                            fit: BoxFit.cover,
                                          )
                                        : const DecorationImage(
                                            image:
                                                AssetImage(imgUserPlaceHolder),
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                            title: RichText(
                              text: TextSpan(
                                text: notification.createdDetails!.isVerified
                                    ? notification.createdDetails!.name
                                    : "${notification.createdDetails!.name} ",
                                style: TextStyle(
                                  color: const Color(0xff121F3F),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                                children: [
                                  WidgetSpan(
                                    child: Visibility(
                                      visible: notification
                                          .createdDetails!.isVerified,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child:
                                              SvgPicture.asset(icVerifyBadge)),
                                    ),
                                  ),
                                  TextSpan(
                                      text: " ${notification.msg!}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: color080,
                                      ))
                                ],
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                convertDateIntoTime(notification.createdAt!),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: const Color(0xff5F5F5F)),
                              ),
                            ),
                            trailing: Container(
                              height: isPostShow ? 50.h : 0,
                              width: isPostShow ? 40.w : 0,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: isPostShow
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            contentImage),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
