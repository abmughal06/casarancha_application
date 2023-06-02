import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../base/base_stateful_widget.dart';
import '../../resources/color_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../widgets/common_appbar.dart';
import '../../widgets/common_widgets.dart';

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
    // NotificationScreenViewModel notificationScreenViewModel =
    //     Provider.of<NotificationScreenViewModel>(context);
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
                      .collection("notification")
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
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

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: notification
                                        .createdDetails!.imageUrl.isEmpty
                                    ? null
                                    : CachedNetworkImageProvider(
                                        notification.createdDetails!.imageUrl,
                                      ),
                                child: notification
                                        .createdDetails!.imageUrl.isEmpty
                                    ? const Icon(
                                        Icons.question_mark,
                                      )
                                    : null,
                              ),
                              title: RichText(
                                text: TextSpan(
                                  text: "",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "${notification.title!} ",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        )),
                                    TextSpan(
                                      text: notification.msg!,
                                    )
                                  ],
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  timeago.format(
                                      DateTime.parse(notification.createdAt!)),
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.black54),
                                ),
                              ),
                            );
                          });
                    }
                  },
                ),
                const Center(
                  child: Text("Coming soon"),
                ),
                // ListView.builder(
                //     shrinkWrap: true,
                //     itemCount: 6,
                //     physics: const BouncingScrollPhysics(),
                //     itemBuilder: (BuildContext context, int index) {
                //       return profileAcceptDecline(
                //         userName: "Marcuswilly889",
                //         subText: "Marcuswilly",
                //         imgUserNet: postProfileImg,
                //       );
                //     })
              ])),
            ],
          ),
        ),
      );
    });
  }
}
