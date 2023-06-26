import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/screens/dashboard/dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'screens/auth/setup_profile_details.dart';
import 'utils/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(
  // (message) => FirebaseMessagingService().backgroundHandler(message));
  //  onBackgroundMessage((message) {
  //   print("=======>>>>>>>>>>$message");
  //   return FirebaseMessagingService().backgroundHandler(message);
  // });
  // LocalNotificationService.initialize()
  // Get.put<ProfileScreenController>(ProfileScreenController());

  await runAgain();
}

runAgain() async {
  DashboardController dashboardController = Get.put(DashboardController());
  DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('designConfig')
      .doc("config")
      .get();
  var data = snapshot.data() ?? {};
  if (data.containsKey("isStoryBtnShow")) {
    dashboardController.isShowStoryBtn.trigger(data['isStoryBtnShow'] ?? true);
  } else {
    dashboardController.isShowStoryBtn.trigger(true);
  }
  if (data.containsKey("isShowSocialLogin")) {
    dashboardController.isShowSocialLogin
        .trigger(data['isShowSocialLogin'] ?? true);
  } else {
    dashboardController.isShowSocialLogin.trigger(true);
  }
  DocumentSnapshot? document;
  if (FirebaseAuth.instance.currentUser?.uid != null) {
    document = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  runApp(MyApp(
    home: (document?.exists ?? false)
        ? const DashBoard()
        : const SetupProfileScreen(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.home}) : super(key: key);
  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          navigatorKey: rootNavigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData ? home! : const LoginScreen();
            },
          ),
        );
      },
    );
  }
}

// ignore: unused_element
class _Unfocus extends StatelessWidget {
  const _Unfocus({Key? key, required this.child}) : super(key: key);
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
