import 'dart:convert';
import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_screen.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var serverKey =
    "key=AAAAYo5xlRE:APA91bHxh2fiJpTazsOCH0k_iqbz9e-Ccg9EaQsXyJna163xViTcwevm04LvlIv7DUBWIboSvKFFsCQdJ9YQUEZHJVxM25zXaO9dash0eGp9dUGeBJu3-va9-zQ0S6LikRBskcdK5HDq";

class FirebaseMessagingService {
  FirebaseMessaging fcmMessage = FirebaseMessaging.instance;

  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  factory FirebaseMessagingService() => _instance;

  FirebaseMessagingService._internal();

  updateUserFcmToken() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        printLog('check1');
        final token = await getFirebaseToken();
        final ref = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid);
        final currentUser = await ref.get();

        if (currentUser.data()!['fcmToken'] == token) {
          printLog('check2');
          return;
        } else {
          ref.update({
            'fcmToken': token,
          });
        }
      } else {
        return;
      }
    } catch (e) {
      printLog(e.toString());
    }
  }

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
      dynamic content,
      String? msg,
      String? groupId,
      required bool isMessage,
      required String notificationType,
      required String appUserId}) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": serverKey,
    };

    var model = await getCurrentUserDetails();
    var ghostmode = await ghostModeOn();

    Map officialBodyFormat = {
      "notification": {
        "title": ghostmode ? "Ghost----" : model.name,
        "body": msg,
        "sound": "default"
      },
      "apns": {
        "headers": {"aps-priority": "10"},
        "payload": {
          "apns": {"sound": "default"}
        }
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "userRequestId": model.id,
        "notification_type": notificationType,
        "content": content,
      },
      "to": devRegToken
    };

    var res = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: header,
      body: jsonEncode(officialBodyFormat),
    );
    final result = await res;
    printLog(result.statusCode.toString());

    if (isMessage == false) {
      final NotificationModel notification = NotificationModel(
        sentToId: appUserId,
        sentById: model.id,
        msg: msg,
        content: content,
        groupId: groupId,
        notificationType: notificationType,
        isRead: false,
        createdDetails: CreatorDetails(
            name: ghostmode ? "Ghost----" : model.name,
            imageUrl: ghostmode ? "" : model.imageStr,
            isVerified: model.isVerified),
        createdAt: DateTime.now().toUtc().toString(),
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(appUserId)
          .collection("notificationList")
          .doc()
          .set(notification.toMap());
    }
  }

  Future<void> sendNotificationToMutipleUsers({
    List<String>? userIds,
    dynamic content,
    String? msg,
    String? groupId,
    required bool isMessage,
    required String notificationType,
  }) async {
    // Fetch FCM tokens for the provided user IDs from your map or database
    Map<String, String> userFCMTokens = await fetchUserFCMTokens(userIds);

    // Iterate through each user and send a notification
    userFCMTokens.forEach((appUserId, devRegToken) async {
      var model = await getCurrentUserDetails();
      var ghostmode = await ghostModeOn();

      Map<String, String> header = {
        "Content-Type": "application/json",
        "Authorization": serverKey,
      };

      Map<String, dynamic> officialBodyFormat = {
        "notification": {
          "title": ghostmode ? "Ghost----" : model.name,
          "body": msg,
          "sound": "default",
        },
        "apns": {
          "headers": {"aps-priority": "10"},
          "payload": {
            "apns": {"sound": "default"},
          },
        },
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done",
          "userRequestId": model.id,
          "notification_type": notificationType,
          "content": content,
        },
        "to": devRegToken,
      };

      var res = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: header,
        body: jsonEncode(officialBodyFormat),
      );

      printLog(res.statusCode.toString());

      if (!isMessage) {
        final NotificationModel notification = NotificationModel(
          sentToId: appUserId,
          sentById: model.id,
          msg: msg,
          content: content,
          groupId: groupId,
          notificationType: notificationType,
          isRead: false,
          createdDetails: CreatorDetails(
            name: ghostmode ? "Ghost----" : model.name,
            imageUrl: ghostmode ? "" : model.imageStr,
            isVerified: model.isVerified,
          ),
          createdAt: DateTime.now().toUtc().toString(),
        );

        FirebaseFirestore.instance
            .collection("users")
            .doc(appUserId)
            .collection("notificationList")
            .doc()
            .set(notification.toMap());
      }
    });
  }

  Future<Map<String, String>> fetchUserFCMTokens(List<String>? userIds) async {
    Map<String, String> userFCMTokens = {};

    for (String userId in userIds!) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (snapshot.exists) {
        String? fcmToken = snapshot.get("fcmToken");
        if (fcmToken != null) {
          userFCMTokens[userId] = fcmToken;
        }
      }
    }

    return userFCMTokens;
  }

  Future<String?> getFirebaseToken() async {
    fcmMessage.requestPermission();
    var token = await fcmMessage.getToken();

    return token;
  }

  Future<void> init(BuildContext context) async {
    // Requesting permission for notifications
    await updateUserFcmToken();

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );

    NotificationSettings settings = await fcmMessage.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');

    // Handling the initial message received when the app is launched from dead (killed state)
    // When the app is killed and a new notification arrives when user clicks on it
    // It gets the data to which screen to open
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });

    // Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(context, message);
    });
  }

  // Handling a notification click event by navigating to the specified screen
  void _handleNotificationClick(
      BuildContext context, RemoteMessage message) async {
    final notificationData = message.data;

    final strNot = notificationData["notification_type"];

    if (strNot == 'msg') {
      final ref = await FirebaseFirestore.instance
          .collection("users")
          .doc(notificationData['userRequestId'])
          .get();

      final appUserData = UserModel.fromMap(ref.data()!);
      Get.to(() => ChatScreen(
          appUserId: appUserData.id,
          creatorDetails: CreatorDetails(
              name: appUserData.name,
              imageUrl: appUserData.imageStr,
              isVerified: appUserData.isVerified)));
    } else if (strNot == "user_follow") {
      navigateToAppUserScreen(notificationData['userRequestId'], context);
    } else {
      final post = PostModel.fromMap(jsonDecode(notificationData['content']));

      Get.to(() => PostDetailScreen(postModel: post, groupId: null));
    }
  }
}
