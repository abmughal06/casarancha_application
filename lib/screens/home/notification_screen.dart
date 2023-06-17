import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../base/base_stateful_widget.dart';
import '../../resources/color_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../widgets/common_appbar.dart';
import '../../widgets/common_widgets.dart';

var notificationCount = 0.obs;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState
    extends BaseStatefulWidgetState<NotificationScreen> {
  final List<Widget> _myTabs = const [
    Tab(text: strNotifications),
    Tab(text: strFollowRequest),
  ];

  @override
  Color? get scaffoldBgColor => colorWhite;

  @override
  bool get shouldHaveSafeArea => false;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return iosBackIcAppBar(title: strNotifications, onTapLead: () => goBack());
  }

  @override
  Widget buildBody(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: DefaultTabController(
          length: _myTabs.length,
          child: Column(
            children: [
              heightBox(14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: commonTabBar(tabsList: _myTabs),
              ),
              heightBox(21.h),
              Expanded(
                  child: TabBarView(children: [
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("notificationlist")
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: TextWidget(
                          text: "No notifications yet",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: color221,
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var data = snapshot.data!.docs[index].data();
                          print("daldasldkasl;dkald;kasd $data");
                          var notification = NotificationModel.fromMap(data);
                          print(notification.id);
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("notificationlist")
                              .doc(snapshot.data!.docs[index].id)
                              .update({"isRead": true});

                          return ListTile(
                            leading: Container(
                              height: 46.h,
                              width: 46.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      notification.createdDetails!.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: RichText(
                              text: TextSpan(
                                text: "",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: const Color(0xff5F5F5F)),
                                children: [
                                  TextSpan(
                                    text:
                                        notification.createdDetails!.isVerified
                                            ? notification.title!
                                            : "${notification.title!} ",
                                    style: TextStyle(
                                      color: const Color(0xff121F3F),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
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
                                  )
                                ],
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                timeago.format(
                                    DateTime.parse(notification.createdAt!)),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: const Color(0xff5F5F5F)),
                              ),
                            ),
                            trailing: notification.imageUrl != null
                                ? notification.imageUrl!.isNotEmpty
                                    ? Image.network(notification.imageUrl!)
                                    : const SizedBox()
                                : const SizedBox(),
                          );
                        },
                      );
                    }
                  },
                ),
                const Center(
                  child: Text("No requests yet"),
                ),
              ])),
            ],
          ),
        ),
      );
    });
  }
}
