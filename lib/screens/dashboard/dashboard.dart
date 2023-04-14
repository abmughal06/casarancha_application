import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_chat_helper.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_message_controller.dart';
import 'package:casarancha/screens/dashboard/dashboard_controller.dart';
import 'package:casarancha/screens/groups/my_groups_screen.dart';
import 'package:casarancha/screens/home/HomeScreen/home_screen.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/screens/search/search_screen.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../resources/color_resources.dart';
import '../home/HomeScreen/home_screen_controller.dart';

class DashBoard extends StatefulWidget {
  DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with AutomaticKeepAliveClientMixin {
  late ProfileScreenController profileScreenController;

  late DashboardController dashboardController;

  @override
  void initState() {
    dashboardController = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : Get.put(DashboardController());
    profileScreenController = Get.put(ProfileScreenController());
    Future.delayed(Duration.zero, () {
      GhostMessageController gmCtrl = GhostChatHelper.shared.gMessageCtrl;
      gmCtrl.createConversationStreamSubscription(
          FirebaseAuth.instance.currentUser?.uid ?? "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
        top: profileScreenController.isGhostModeOn.value,
        bottom: profileScreenController.isGhostModeOn.value,
        child: Scaffold(
          body: Container(
            decoration: profileScreenController.isGhostModeOn.value
                ? BoxDecoration(
                    border: Border.all(
                      width: 2.5,
                      color: Colors.red,
                    ),
                  )
                : null,
            child: PageView(
              controller: dashboardController.pageController,
              onPageChanged: (value) {},
              children: [
                HomeScreen(),
                SearchScreen(),
                MyGroupsScreen(),
                ChatListScreen(),
                ProfileScreen(),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Card(
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: profileScreenController.isGhostModeOn.value ? 10.w : 0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                50,
              ),
            ),
            // elevation: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w),
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          dashboardController.pageController.jumpToPage(0);
                        },
                        icon: SvgPicture.asset(
                          dashboardController.currentIndex.value == 0
                              ? icBottomSelHome
                              : icBottomDeSelHome,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          dashboardController.pageController.jumpToPage(1);
                        },
                        icon: SvgPicture.asset(
                          dashboardController.currentIndex.value == 1
                              ? icBottomSelSearch
                              : icBottomDeSelSearch,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          dashboardController.pageController.jumpToPage(2);
                        },
                        icon: SvgPicture.asset(
                          dashboardController.currentIndex.value == 2
                              ? icBottomSelGrp
                              : icBottomDeSelGrp,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          dashboardController.pageController.jumpToPage(3);
                        },
                        icon: SvgPicture.asset(
                          dashboardController.currentIndex.value == 3
                              ? icBottomSelChat
                              : icBottomDeSelChat,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          dashboardController.pageController.jumpToPage(4);
                        },
                        icon: profileScreenController.isGettingUserData.value
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.red.withOpacity(
                                  0.1,
                                ),
                                backgroundImage: NetworkImage(
                                  profileScreenController.user.value.imageStr,
                                ),
                              ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}

IconButton ghostModeBtn({HomeScreenController? homeCtrl, double? iconSize}) {
  HomeScreenController homeScreenController =
      homeCtrl ?? Get.put(HomeScreenController());
  return IconButton(
    iconSize: iconSize,
    onPressed: () {
      homeScreenController.profileScreenController.toggleGhostMode();
    },
    icon: SvgPicture.asset(icGhostMode,
        color: homeScreenController.profileScreenController.isGhostModeOn.value
            ? colorPrimaryA05
            : null),
  );
}
