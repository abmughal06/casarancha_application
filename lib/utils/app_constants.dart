import 'package:flutter/material.dart';

import '../resources/localization_text_strings.dart';

enum BottomSheetMenuType { isPostMenu, isReportPost, isDoneReport }

class AppConstant {
  static const int passwordMinText = 6;

  static const int emailTextLimit = 40;
  static const int fullNameTextLimit = 30;

  static const String appPackageName = "com.zb.casarancha";

  static const String deviceIdPre = "deviceId";
  static const String deviceTypePre = "deviceType";
  static const String userNameSignUpPre = "userNameSignUp";
  static const String userEmailSignUpPre = "userEmailSignUp";
  static const String userDobSignUpPre = "userDobSignUp";
  static const String userPasswordSignUpPre = "userPasswordSignUp";
  static const String userConformPwdSignUpPre = "userConformPwdSignUp";

  static const String profileIdPre = "profileId";
  static const String signupResponsePre = "signupResponsePre";

  static const String userTokenPre = "userToken";
  static const String isLoggedInPre = "isLoggedIn";

  static final RegExp regexEmoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  Widget emojiSize(String content, Color color) {
    final Iterable<Match> matches = regexEmoji.allMatches(content);
    if (matches.isEmpty) {
      return SelectableText(
        content,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      );
    }

    return RichText(
        text: TextSpan(children: [
      for (var t in content.characters)
        TextSpan(
            text: t,
            style: TextStyle(
                fontSize: regexEmoji.allMatches(t).isNotEmpty ? 24.0 : 12.0,
                color: color,
                fontWeight: FontWeight.w500)),
    ]));
  }

  static List<String> profileBottomSheetList = [
    strEditProfile,
    strSavedPosts,
    "Get Verified",
    strSettings,
    strAbout,
    strTermsCondition,
    strPrivacyPolicy,
    "Log out",
    "Delete Account"
  ];
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

int homePageIndex = 0,
    searchPageIndex = 1,
    groupPageIndex = 2,
    chatPageIndex = 3,
    profilePageIndex = 4;

String storyProfileImg =
    "https://media.istockphoto.com/photos/millennial-male-team-leader-or"
    "ganize-virtual-workshop-with-employees-picture-id1300972574?b=1&k=20&m=1300972574&s=1"
    "70667a&w=0&h=2nBGC7tr0kWIU8zRQ3dMg-C5JLo9H2sNUuDjQ5mlYfo=";

String postProfileImg =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeGC2zO9XphU0L4bmk9_Htveabe0LkIuQSgWpb5G_P&s";

String postImgTemp =
    "https://thumbs.dreamstime.com/b/beautiful-rain-forest-ang-ka-nature-trail-doi-"
    "inthanon-national-park-thailand-36703721.jpg";
String imgNavBarUser =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTe"
    "GC2zO9XphU0L4bmk9_Htveabe0LkIuQSgWpb5G_P&s";
String imgUrlStoryView =
    "https://files.oyebesmartest.com/public/img-subcategory/cb-background-qoRpk.webp";

String musicImgUrl = "assets/images/musicSplash.jpg";

String musicMp3 =
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';

String videoCallBack =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIV99IJOGUBMQBy9kccOQsAyq36yzt0BRYUw&usqp=CAU";
