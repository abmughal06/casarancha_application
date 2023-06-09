import 'dart:convert';
import 'dart:developer';
import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/profile/ProfileScreen/profile_screen_controller.dart';

var serverKey =
    "key=AAAAYo5xlRE:APA91bHxh2fiJpTazsOCH0k_iqbz9e-Ccg9EaQsXyJna163xViTcwevm04LvlIv7DUBWIboSvKFFsCQdJ9YQUEZHJVxM25zXaO9dash0eGp9dUGeBJu3-va9-zQ0S6LikRBskcdK5HDq";

class FirebaseMessagingService {
  ProfileScreenController? profileScreenController;
  FirebaseMessaging fcmMessage = FirebaseMessaging.instance;

  Future<UserModel> getCurrentUserDetails() async {
    var ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    var getData = await ref.get();
    var data = getData.data();
    var model = UserModel.fromMap(data!);
    return model;
  }

  Future<bool> ghostModeOn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isGhostEnable') ?? false;
  }

  sendNotificationToUser(
      {String? devRegToken,
      String? imageUrl,
      String? msg,
      required String appUserId}) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": serverKey,
    };

    var model = await getCurrentUserDetails();
    var ghostmode = await ghostModeOn();

    Map bodyNotification = {
      "title": ghostmode ? "Ghost----${generateRandomString(7)}" : model.name,
      "body": msg
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userRequestId": appUserId,
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
      id: appUserId,
      appUserId: FirebaseAuth.instance.currentUser!.uid,
      msg: msg,
      imageUrl: imageUrl != null
          ? imageUrl.isNotEmpty
              ? imageUrl
              : ''
          : '',
      isRead: false,
      createdDetails: CreatorDetails(
          name: ghostmode ? "Ghost----${generateRandomString(7)}" : model.name,
          imageUrl: ghostmode ? "" : model.imageStr,
          isVerified: model.isVerified),
      createdAt: DateTime.now().toIso8601String(),
    );
    log("===============>>>>>>>>$notification");
    FirebaseFirestore.instance
        .collection("users")
        .doc(appUserId)
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
