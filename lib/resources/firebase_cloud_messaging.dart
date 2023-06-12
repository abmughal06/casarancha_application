import 'dart:convert';
import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../screens/profile/ProfileScreen/profile_screen_controller.dart';

var serverKey =
    "key=AAAAYo5xlRE:APA91bHxh2fiJpTazsOCH0k_iqbz9e-Ccg9EaQsXyJna163xViTcwevm04LvlIv7DUBWIboSvKFFsCQdJ9YQUEZHJVxM25zXaO9dash0eGp9dUGeBJu3-va9-zQ0S6LikRBskcdK5HDq";

class FirebaseMessagingService {
  ProfileScreenController? profileScreenController;
  FirebaseMessaging fcmMessage = FirebaseMessaging.instance;

  sendNotificationToUser(
      {String? devRegToken,
      String? userReqID,
      String? title,
      CreatorDetails? creatorDetails,
      String? cname,
      String? cimg,
      bool? cisVerified,
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

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: header,
      body: jsonEncode(officialBodyFormat),
    );

    final NotificationModel notification = NotificationModel(
      id: userReqID,
      msg: msg,
      title: title,
      isRead: false,
      createdDetails: CreatorDetails(
          name: creatorDetails!.name,
          imageUrl: creatorDetails.imageUrl,
          isVerified: creatorDetails.isVerified),
      createdAt: DateTime.now().toIso8601String(),
    );
    print("===============>>>>>>>>$notification");
    FirebaseFirestore.instance
        .collection("users")
        .doc(userReqID)
        .collection("notificationlist")
        .doc()
        .set(notification.toMap());
  }

  Future<String?> getFirebaseToken() async {
    fcmMessage.requestPermission();
    var token = await fcmMessage.getToken();

    return token;
  }
}
