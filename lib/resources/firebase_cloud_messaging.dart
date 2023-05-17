import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:casarancha/screens/chat/GhostMode/ghost_chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'local_notification_service.dart';

var serverKey =
    "key=AAAAYo5xlRE:APA91bHxh2fiJpTazsOCH0k_iqbz9e-Ccg9EaQsXyJna163xViTcwevm04LvlIv7DUBWIboSvKFFsCQdJ9YQUEZHJVxM25zXaO9dash0eGp9dUGeBJu3-va9-zQ0S6LikRBskcdK5HDq";

class FirebaseMessagingService {
  FirebaseMessaging fcmMessage = FirebaseMessaging.instance;

  // initializeCloudMessaging() {
  //   // Terminated
  //   FirebaseMessaging.instance.getInitialMessage().then(
  //     (message) {
  //       print("FirebaseMessaging.instance.getInitialMessage");
  //       if (message != null) {
  //         print("New Notification");
  //         // if (message.data['_id'] != null) {
  //         //   Navigator.of(context).push(
  //         //     MaterialPageRoute(
  //         //       builder: (context) => DemoScreen(
  //         //         id: message.data['_id'],
  //         //       ),
  //         //     ),
  //         //   );
  //         // }
  //       }
  //     },
  //   );
  //   //foreground

  //   FirebaseMessaging.onMessage.listen(
  //     (message) {
  //       print("FirebaseMessaging.onMessage.listen");
  //       if (message.notification != null) {
  //         print(message.notification!.title);
  //         print(message.notification!.body);
  //         print("message.data11 ${message.data}");
  //         // LocalNotificationService.createanddisplaynotification(message);
  //       }
  //     },
  //   );

  //   //background
  //   FirebaseMessaging.onMessageOpenedApp.listen(
  //     (message) {
  //       print("FirebaseMessaging.onMessageOpenedApp.listen");
  //       if (message.notification != null) {
  //         print(message.notification!.title);
  //         print(message.notification!.body);
  //         print("message.data22 ${message.data['_id']}");
  //       }
  //     },
  //   );
  // }

  // Future<void> backgroundHandler(RemoteMessage message) async {
  //   print(message.data.toString());
  //   print(message.notification!.title);
  // }

  static sendNotificationToUser(
      {String? devRegToken,
      String? userReqID,
      String? title,
      String? msg}) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": serverKey,
    };

    Map bodyNotification = {"title": title, "body": msg};

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userRequestId": userReqID,
    };

    Map officialBodyFormat = {
      "notification": bodyNotification,
      "priority": "high",
      "data": dataMap,
      "to": devRegToken,
    };

    // ignore: unused_local_variable
    var responseHttpNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: header,
      body: jsonEncode(officialBodyFormat),
    );
  }

  // Future<void> sendNotification(
  //     {String? token, String? id, String? name}) async {
  //   try {
  //     var body = {
  //       "to": token,
  //       "application": {"title": name, "body": id}
  //     };
  //     var response =
  //         await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
  //             headers: {
  //               HttpHeaders.contentTypeHeader: 'application/json',
  //               HttpHeaders.authorizationHeader: serverKey
  //             },
  //             body: json.encode(body));
  //     if (response.statusCode == 200) {
  //       print("=============== <<<<<<<< notification send");
  //     } else {
  //       print("=============== <<<<<<<< error = ${response.body}");
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  Future<String?> getFirebaseToken() async {
    fcmMessage.requestPermission();
    var token = await fcmMessage.getToken();

    return token;
  }
}
