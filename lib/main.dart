import 'package:casarancha/firebase_options.dart';
import 'package:casarancha/provider_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'authenticator.dart';
import 'utils/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'Casarancha', options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

String? getToken = '';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        //  MaterialApp(
        //     debugShowCheckedModeBanner: false,
        //     theme: ThemeData(
        //       primarySwatch: Colors.red,
        //     ),
        //     home: const Test());
        ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return StreamBuilder<User?>(
          initialData: null,
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return ProviderApp(
              app: Portal(
                child: GetMaterialApp(
                  navigatorKey: rootNavigatorKey,
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.red,
                  ),
                  home: const Authenticate(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  String? name;

  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.ref('user');
    ref.onValue.listen((event) {
      name = event.snapshot.value.toString();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(name ?? "nope"),
      ),
    );
  }
}
