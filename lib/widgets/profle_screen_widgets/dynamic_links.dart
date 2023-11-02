import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

// class DynamicLinksProvider {
//   Future<String> createLink(String refCode) async {
//     final String url = "http://com.zb.casarancha?ref=$refCode";
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//         link: Uri.parse(url), uriPrefix: "https://casarancha.page.link");

//     final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
//     final reflink = await link.buildShortLink(parameters);
//     return reflink.shortUrl.toString();
//   }

//   void intializeDynamicLinks() async {
//     final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();
//     if (instanceLink != null) {
//       final Uri reflink = instanceLink.link;
//       FlutterShare.share(
//           title: 'this is the link ${reflink.queryParameters['ref']}');
//     }
//   }
// }

// FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

// class FirebaseDynamicLinkService {
//   static Future<String> createDynamicLink(bool? short) async {
//     final user = FirebaseAuth.instance.currentUser!.uid;
//     String linkMessage;

//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://casarancha.page.link',
//       link: Uri.parse('https://casarancha.com/profile?id=$user'),
//       androidParameters: AndroidParameters(
//         fallbackUrl: Uri.parse(
//             'https://play.google.com/store/apps/details?id=com.zb.casarancha'),
//         packageName: 'com.zb.casarancha',
//       ),
//       iosParameters: IOSParameters(
//         bundleId: 'com.zb.casarancha',
//         fallbackUrl:
//             Uri.parse('https://apps.apple.com/pk/app/casa-rancha/id1666539952'),
//       ),
//     );

//     Uri url;
//     if (short!) {
//       final ShortDynamicLink shortLink =
//           await FirebaseDynamicLinks.instance.buildShortLink(parameters);
//       url = shortLink.shortUrl;
//     } else {
//       url = await FirebaseDynamicLinks.instance.buildLink(parameters);
//     }

//     linkMessage = url.toString();
//     return linkMessage;
//   }

//   static Future<void> initDynamicLink() async {

//     final PendingDynamicLinkData? data =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//     try {
//       final Uri deepLink = data!.link;
//       var isProfile = deepLink.pathSegments.contains('id');
//       if (isProfile) {
//         try {
//           await firebaseFirestore
//               .collection('users')
//               .doc(FirebaseAuth.instance.currentUser!.uid)
//               .get()
//               .then((snapshot) {
//             return Navigator.push(BuildContext as BuildContext,
//                 MaterialPageRoute(builder: (context) => const ProfileScreen()));
//           });
//         } catch (e) {
//           print(e);
//         }
//       }
//     } catch (e) {
//       print('No deepLink found');
//     }
//   }
// }
class DynamicLinkHelper {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  Future<void> initDynamicLinks(
      Function(PendingDynamicLinkData openLink) dataObj) async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      dataObj(dynamicLinkData);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  Future<void> createDynamicLink(String screenPath) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://casarancha.page.link',
      link: Uri.parse("https://casarancha.com/profile?id=$screenPath"),
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
