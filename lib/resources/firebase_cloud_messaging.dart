import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  FirebaseMessaging message = FirebaseMessaging.instance;

  void requestPermission() async {
    NotificationSettings settings = await message.requestPermission(
      alert: true,
      announcement: true,
      criticalAlert: true,
      carPlay: true,
      provisional: true,
      sound: true,
      badge: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}
  }

  Future<String?> getFirebaseToken() async {
    var token = await message.getToken();
    // print(token);
    return token;
  }
}
