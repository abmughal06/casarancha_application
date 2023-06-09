import 'dart:developer';
import 'dart:io';

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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../resources/color_resources.dart';
import '../home/HomeScreen/home_screen_controller.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with AutomaticKeepAliveClientMixin {
  ProfileScreenController profileScreenController =
      Get.put(ProfileScreenController());

  late DashboardController dashboardController;

  @override
  void initState() {
    dashboardController = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : Get.put(DashboardController());

    Future.delayed(Duration.zero, () {
      GhostMessageController gmCtrl = GhostChatHelper.shared.gMessageCtrl;
      gmCtrl.createConversationStreamSubscription(
          FirebaseAuth.instance.currentUser?.uid ?? "");
    });

    getPrefData();
    super.initState();
  }

  getPrefData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Future.delayed(const Duration(seconds: 0)).then((value) {
      var getVal = sharedPreferences.getBool('isGhostEnable') ?? false;
      log("000000000000000000000");
      if (getVal == true) {
        profileScreenController.toggleGhostMode();
      } else {
        log('no val preference');
      }
      log(getVal.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => SafeArea(
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
                const HomeScreen(),
                const SearchScreen(),
                const MyGroupsScreen(),
                ChatListScreen(),
                const ProfileScreen(),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Card(
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: Platform.isAndroid ||
                      profileScreenController.isGhostModeOn.value
                  ? 10.w
                  : 0.w,
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

IconButton ghostModeBtn({HomeScreenController? homeCtrl, double? iconSize}) {
  HomeScreenController homeScreenController =
      homeCtrl ?? Get.put(HomeScreenController());

  return IconButton(
    iconSize: iconSize,
    onPressed: () async {
      // setState(() {});
      // SharedPreferences sharedPreferences =
      //     await SharedPreferences.getInstance();

      // sharedPreferences.getBool('isGhostEnable') == false
      //     ? null
      //     : await sharedPreferences.setBool('isGhostEnable',
      //         homeScreenController.profileScreenController.isGhostModeOn.value);

      // await appPreferencesController.getString('isGhostEnable') == true
      //     ? null
      //     : await appPreferencesController.setString(
      //         'isGhostEnable',
      //         homeScreenController.profileScreenController.isGhostModeOn.value
      //             .toString());
      homeScreenController.profileScreenController.toggleGhostMode();
      //     await appPreferencesController.setString(
      //         'isGhostEnable',homeScreenController.profileScreenController.isGhostModeOn.value
      //             .toString());
      //              var getVal = await appPreferencesController.getString('isGhostEnable');
      //   log("0-0--------------------");
      //   log(getVal.toString());
      //     print(appPreferencesController.getString('isGhostEnable'));
    },
    icon: SvgPicture.asset(icGhostMode,
        color: homeScreenController.profileScreenController.isGhostModeOn.value
            ? colorPrimaryA05
            : null),
  );
}
