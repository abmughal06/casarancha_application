import 'dart:developer';
import 'package:casarancha/authenticator.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/profile/ProfileScreen/provider/profile_provider.dart';
import 'package:casarancha/screens/profile/account_recovery.dart';
import 'package:casarancha/screens/profile/get_verified.dart';
import 'package:casarancha/screens/profile/help.dart';
import 'package:casarancha/screens/profile/settings/settings.dart';
import 'package:casarancha/widgets/shared/alert_dialog.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../resources/color_resources.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/providers/auth_provider.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/saved_post_screen.dart';
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
      List<String> profileBottomSheetList = [
        appText(context).strEditProfile,
        appText(context).strSavedPosts,
        appText(context).strAccountRecovery,
        appText(context).strGetVerified,
        appText(context).strSettings,
        appText(context).language,
        appText(context).strInviteFrnds,
        appText(context).strAbout,
        appText(context).strTermsCondition,
        appText(context).strPrivacyPolicy,
        appText(context).strHelp,
        appText(context).strLogout,
        appText(context).strDeleteAct,
      ];
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
              child: Consumer<UserModel?>(builder: (context, user, b) {
                if (user == null) {
                  return centerLoader();
                }

                return ListView.builder(
                  itemCount: profileBottomSheetList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: textMenuItem(
                        text: profileBottomSheetList[index],
                        color: index > 10
                            ? Colors.red
                            : index == 5
                                ? Colors.blue.shade700
                                : null,
                        onTap: () {
                          Get.back();
                          _onTapSheetItem(
                              index: index, context: context, userModel: user);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      );
    },
  );
}

_onTapSheetItem(
    {required int index,
    required BuildContext context,
    UserModel? userModel}) async {
  switch (index) {
    case 0:
      Get.to(() => EditProfileScreen(user: userModel));
      break;
    case 1:
      Get.to(() => const SavedPostScreen());
      break;
    case 2:
      Get.to(() => const AccountRecovery());
      break;
    case 3:
      //getVerify
      Get.to(() => const GetVerifiedScreen());
      break;
    case 4:
      Get.to(() => const ProfileSettings());
      break;
    case 5:
      Get.to(() => const LannguageSelectionPage());
      break;

    case 6:
      //invite freinds
      inviteFriends();
      break;

    case 7:
      //about
      launchUrls("https://casarancha.com/about/");
      break;

    case 8:
      //terms

      launchUrls("https://casarancha.com/terms-conditions/");
      break;
    case 9:
      //privacy

      launchUrls("https://casarancha.com/privacy-policy/");
      break;
    case 10:
      //privacy

      Get.to(() => const HelpCenter());
      break;
    case 11:
      //logout
      showDialog(
          context: context,
          builder: (_) => CustomAdaptiveAlertDialog(
              title: appText(context).strLogout,
              alertMsg: appText(context).strConfirmLogout,
              actiionBtnName: appText(context).strLogout,
              onAction: () => AuthenticationProvider(FirebaseAuth.instance)
                      .signOut()
                      .whenComplete(() {
                    // User? user;
                    Get.offAll(() => const LoginScreen());
                  })));

      break;
    case 12:
      //logout
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAdaptiveAlertDialog(
            title: appText(context).strDeleteAccount,
            alertMsg: appText(context).strConfirmationDeleteAccount,
            actiionBtnName: appText(context).strDelete,
            onAction: () => ProfileProvider().deleteUserAccount(),
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
    DynamicLinkHelper().createDynamicLink();
  } catch (e) {
    printLog('Error sharing: $e');
  }
}
