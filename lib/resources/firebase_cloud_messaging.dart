import 'dart:convert';
import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var serverKey =
    "key=AAAAYo5xlRE:APA91bHxh2fiJpTazsOCH0k_iqbz9e-Ccg9EaQsXyJna163xViTcwevm04LvlIv7DUBWIboSvKFFsCQdJ9YQUEZHJVxM25zXaO9dash0eGp9dUGeBJu3-va9-zQ0S6LikRBskcdK5HDq";

class FirebaseMessagingService {
  FirebaseMessaging fcmMessage = FirebaseMessaging.instance;

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
      String? imageUrl,
      String? msg,
      required bool isMessage,
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
        "userRequestId": appUserId,
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
            name: ghostmode ? "Ghost----" : model.name,
            imageUrl: ghostmode ? "" : model.imageStr,
            isVerified: model.isVerified),
        createdAt: DateTime.now().toUtc().toString(),
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(appUserId)
          .collection("notificationlist")
          .doc()
          .set(notification.toMap());
    }
  }

  Future<String?> getFirebaseToken() async {
    fcmMessage.requestPermission();
    var token = await fcmMessage.getToken();

    return token;
  }
}
