import 'dart:developer';

import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/firebase_cloud_messaging.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

class DynamicLinkHelper {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  Future<void> initDynamicLinks(context) async {
    dynamicLinks.getInitialLink().then((value) async {
      if (value != null) {
        final Uri deepLink = value.link;
        log('deepLinks : $deepLink');

        var link = deepLink.queryParameters['id'];
        log('link : $link');

        if (link != null) {
          navigateToAppUserScreen(link, context);
        }

        var senderUser = await getDynamicLinkSenderData(link);

        FirebaseMessagingService().sendNotificationToUser(
          isMessage: false,
          notificationType: 'dynamicLink',
          appUserId: link!,
          msg: 'Your friend is on casarancha, follow now',
          content: null,
          devRegToken: senderUser!.fcmToken,
          groupId: null,
        );
      }
    });
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      final Uri deepLink = dynamicLinkData.link;
      log('deepLinks : $deepLink');

      var link = deepLink.queryParameters['id'];
      log('link : $link');

      if (link != null) {
        navigateToAppUserScreen(link, context);
        var senderUser = await getDynamicLinkSenderData(link);

        FirebaseMessagingService().sendNotificationToUser(
          isMessage: false,
          notificationType: 'dynamicLink',
          appUserId: link,
          msg: 'is now on casarancha, follow now',
          content: null,
          devRegToken: senderUser!.fcmToken,
          groupId: null,
        );
      }
    }).onError((error) {
      printLog('onLink error');
      printLog(error.message);
    });
  }

  Future<UserModel?> getDynamicLinkSenderData(id) async {
    final ref =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    return UserModel.fromMap(ref.data()!);
  }

  Future<void> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://casarancha.page.link',
      link: Uri.parse("https://casarancha.com/profile?id=$currentUserUID"),
      androidParameters: const AndroidParameters(
        packageName: 'com.zb.casarancha',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.zb.casarancha',
        minimumVersion: '1',
      ),
    );

    Uri url;

    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    url = shortLink.shortUrl;
    Share.share(
        "I'm on CasaRancha. Install the app to follow my photos and videos. ${url.toString()}");
  }
}
