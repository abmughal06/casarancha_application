import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/base_stateful_widget.dart';
import '../../resources/color_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_appbar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/home_page_widgets.dart';

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
                Center(
                  child: Container(
                    child: Text("Coming soon"),
                  ),
                ),
                Center(
                  child: Container(
                    child: Text("Coming soon"),
                  ),
                )
                /*  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 0,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 28.w, vertical: 11.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profileImgName(
                              // onTapOtherProfile: ()=> AppUtils.instance.push(enterPage: const OtherProfileScreen()),
                              imgUserNet: postProfileImg,
                              isVerifyWithName: true,
                              isVerifyWithIc: false,
                              idIsVerified: true,
                              userName: "Esther85",
                              subText: "2 min ago",
                              txtWithUName: strLikeYourPic,
                            ),
                          ],
                        ),
                      );
                    }), */
                /*   ListView.builder(
                    shrinkWrap: true,
                    itemCount: 6,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return profileAcceptDecline(
                        userName: "Marcuswilly889",
                        subText: "Marcuswilly",
                        imgUserNet: postProfileImg,
                      );
                    }) */
              ])),
            ],
          ),
        ),
      );
    });
  }
}
