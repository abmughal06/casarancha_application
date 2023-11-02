import 'dart:developer';
import 'dart:io';
import 'package:casarancha/screens/profile/ProfileScreen/provider/profile_provider.dart';
import 'package:casarancha/screens/profile/get_verified.dart';
import 'package:casarancha/screens/profile/settings/settings.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../resources/color_resources.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/providers/auth_provider.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/saved_post_screen.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_utils.dart';
import '../common_widgets.dart';
import '../home_page_widgets.dart';
import 'dynamic_links.dart';

bottomSheetProfile(context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
      ),
      builder: (BuildContext context) {
        return Container(
            height: 550,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  heightBox(10.h),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 6.h,
                      width: 78.w,
                      decoration: BoxDecoration(
                        color: colorDD9,
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                      ),
                    ),
                  ),
                  heightBox(10.h),
                  Expanded(
                    child: ListView.builder(
                        itemCount: AppConstant.profileBottomSheetList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: textMenuItem(
                                text: AppConstant.profileBottomSheetList[index],
                                color: index > 7 ? Colors.red : null,
                                onTap: () {
                                  Get.back();
                                  _onTapSheetItem(
                                      index: index, context: context);
                                }),
                          );
                        }),
                  )
                ]));
      });
}

_onTapSheetItem({required int index, required BuildContext context}) async {
  switch (index) {
    case 0:
      Get.to(() => const EditProfileScreen());
      break;
    case 1:
      Get.to(() => const SavedPostScreen());
      break;
    case 2:
      //getVerify
      Get.to(() => const GetVerifiedScreen());
      break;
    case 3:
      Get.to(() => const ProfileSettings());
      break;

    case 4:
      //invite freinds
      inviteFriends();
      // DynamicLinksProvider().createLink('123');
      break;

    case 5:
      //about
      launchUrls("https://casarancha.com/about/");
      break;

    case 6:
      //terms

      launchUrls("https://casarancha.com/terms-conditions/");
      break;
    case 7:
      //privacy

      launchUrls("https://casarancha.com/privacy-policy/");
      break;
    case 8:
      //logout
      // profileScreenController.logout();
      AuthenticationProvider(FirebaseAuth.instance).signOut().whenComplete(() {
        User? user;
        if (user == null) {
          Get.offAll(() => const LoginScreen());
        }
      });

      break;
    case 9:
      //logout
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete your Account?'),
            content: const Text(
                '''If you select Delete we will delete your account on our server.

Your app data will also be deleted and you won't be able to retrieve it.

'''),
            actions: [
              TextButton(
                child: const TextWidget(text: 'Cancel'),
                onPressed: () {
                  Get.back();
                },
              ),
              TextButton(
                child: const TextWidget(
                  text: 'Delete',
                  color: Colors.red,
                ),
                onPressed: () {
                  // Call the delete account function
                  ProfileProvider().deleteUserAccount();
                },
              ),
            ],
          );
        },
      );
      break;
  }
}

void launchUrls(String url) async {
  Uri? uri = Uri.tryParse(url);
  if (uri != null) {
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      log("Can't launch url => $url");
    }
  } else {
    log("$url is not valid");
  }
}

inviteFriends() async {
  try {
    DynamicLinkHelper()
        .createDynamicLink(FirebaseAuth.instance.currentUser!.uid);
    // final link = await FirebaseDynamicLinkService.createDynamicLink(false);
    // print(link);
    // await FlutterShare.share(
    //   title: 'Invite Friends',
    //   text:
    //       "I'm on CasaRancha as @. Install the app to follow my photos and videos.",
    //   linkUrl: Platform.isAndroid
    //       ? 'https://casarancha.com/profile?id=$user'
    //       : "https://apps.apple.com/us/app/casa-rancha/id1666539952", // Replace with your app's Play Store URL
    //   chooserTitle: 'Share via', // You can customize this title
    // );
  } catch (e) {
    printLog('Error sharing: $e');
  }
}
