import 'dart:convert';
import 'package:casarancha/models/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class FirebaseMessagingService {
  FirebaseMessaging fcmMessage = FirebaseMessaging.instance;
  UserModel? userModel;
  final title = 'New message!';
  final emessage = 'You have a new message.';

  final serverKey =
      "AAAAYo5xlRE:APA91bHxh2fiJpTazsOCH0k_iqbz9e-Ccg9EaQsXyJna163xViTcwevm04LvlIv7DUBWIboSvKFFsCQdJ9YQUEZHJVxM25zXaO9dash0eGp9dUGeBJu3-va9-zQ0S6LikRBskcdK5HDq";
  void requestPermission() async {
    NotificationSettings settings = await fcmMessage.requestPermission(
      alert: true,
      announcement: true,
      criticalAlert: true,
      carPlay: true,
      provisional: true,
      sound: true,
      badge: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission Granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Permission Granted for provisional");
    } else {
      print("Permission Denied");
    }
  }

  initInfo() {
    var androidInitialize = const AndroidInitializationSettings('');
    var initializationSettings = InitializationSettings(
      android: androidInitialize,
    );
    FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (details) {},
    );
  }

  Future<String?> getFirebaseToken() async {
    var token = await fcmMessage.getToken();
    return token;
  }
}

  // sendNotification() async {
  //   await fcmMessage.sendMessage(to: userModel!.fcmToken);
  // }

  // Future<void> sendFCMRequest(
  //     String fcmToken, String title, String message) async {
  //   final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  //   final headers = <String, String>{
  //     'Content-Type': 'application/json',
  //     'Authorization': 'key=<$serverKey>',
  //   };
  //   Map<String, dynamic> body = {
  //     'to': "fcmToken",
  //     'notification': {
  //       'title': title,
  //       'body': message,
  //       'sound': 'default',
  //       'badge': '1',
  //     },
  //     'priority': 'high',
  //     'data': {
  //       'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //     },
  //   };

  //   await fcmMessage.sendMessage(
  //     to: userModel!.fcmToken,
  //     // data: body,
  //     messageType: "",
  //     messageId: "",
  //     collapseKey: "",
  //   );

  //   await http.post(url, headers: headers, body: json.encode(body));
  // }