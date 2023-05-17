// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize() {
//     // initializationSettings  for Android
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//     );

//     notificationsPlugin.initialize(
//       initializationSettings,
//       // onDidReceiveBackgroundNotificationResponse: (details) {
//       //   if (details.id != null) {
//       //     print("Router Value1234 ${details.id}");
//       //   }
//       // },
//       // onDidReceiveNotificationResponse: (details) {
//       //   if (details.id != null) {
//       //     print("Router  ${details.id}");
//       //   }
//       // },
//       onSelectNotification: (String? id) async {
//         print("onSelectNotification");
//         if (id!.isNotEmpty) {
//           print("Router Value1234 $id");

//           // Navigator.of(context).push(
//           //   MaterialPageRoute(
//           //     builder: (context) => DemoScreen(
//           //       id: id,
//           //     ),
//           //   ),
//           // );
//         }
//       },
//     );
//   }

//   static void createanddisplaynotification(RemoteMessage message) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           "casarancha_application",
//           "casarancha_applicationappChannel",
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       );

//       await notificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//         payload: message.data['_id'],
//       );
//     } on Exception catch (e) {
//       print(e);
//     }
//   }
// }
