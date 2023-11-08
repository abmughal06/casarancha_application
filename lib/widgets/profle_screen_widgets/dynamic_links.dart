import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

class DynamicLinkHelper {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  Future<void> initDynamicLinks(context) async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;

      var link = deepLink.queryParameters['id'];

      if (link != null) {
        navigateToAppUserScreen(link, context);
      }
    }).onError((error) {
      printLog('onLink error');
      printLog(error.message);
    });
  }

  Future<void> createDynamicLink() async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://casarancha.page.link',
      link: Uri.parse("https://casarancha.com/profile?id=$userID"),
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
    Share.share(url.toString());
  }
}
