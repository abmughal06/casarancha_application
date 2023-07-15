import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../resources/color_resources.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final notifications = context.watch<List<NotificationModel>?>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Notifications",
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            onTap: (v) {},
            labelColor: colorPrimaryA05,
            unselectedLabelColor: colorAA3,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
            indicatorColor: Colors.yellow,
            indicatorPadding:
                const EdgeInsets.symmetric(horizontal: 75, vertical: 5),
            tabs: const [
              Tab(text: "Notification"),
              Tab(text: "Follow Requests"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Consumer<List<NotificationModel>?>(
              builder: (context, notifications, b) {
                if (notifications == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (notifications.isNotEmpty) {
                    return ListView.builder(
                      itemCount: notifications.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        // var data = snapshot.data!.docs[index].data();
                        var notification = notifications[index];
                        // FirebaseFirestore.instance
                        //     .collection("users")
                        //     .doc(FirebaseAuth.instance.currentUser!.uid)
                        //     .collection("notificationlist")
                        //     .doc(snapshot.data!.docs[index].id)
                        //     .update({"isRead": true});
                        if (notification.appUserId != null) {
                          if (notification.appUserId !=
                              FirebaseAuth.instance.currentUser!.uid) {
                            // log("daldasldkasl;dkald;kasd $data");
                            return ListTile(
                              leading: Container(
                                height: 46.h,
                                width: 46.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.amber,
                                  image: notification
                                          .createdDetails!.imageUrl.isNotEmpty
                                      ? DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              notification
                                                  .createdDetails!.imageUrl),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
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
                                            child: SvgPicture.asset(
                                                icVerifyBadge)),
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
                              trailing: notification.imageUrl != null
                                  ? notification.imageUrl!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: notification.imageUrl!)
                                      : const SizedBox()
                                  : const SizedBox(),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else {
                    return Center(
                      child: TextWidget(
                        text: "No notifications yet",
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: color221,
                      ),
                    );
                  }
                }
              },
            ),
            const Center(
              child: Text("No requests yet"),
            ),
          ],
        ),
      ),
    );
  }
}
