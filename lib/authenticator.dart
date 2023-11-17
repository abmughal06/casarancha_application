import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/auth/setup_profile_details.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/utils/app_utils.dart';
import 'package:casarancha/widgets/profle_screen_widgets/dynamic_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final _dhelper = DynamicLinkHelper();

  @override
  void initState() {
    _dhelper.initDynamicLinks(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseAuth.instance.currentUser?.uid != null
            ? FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots()
            : null,
        initialData: null,
        builder: (context, snapshot) {
          // printLog(snapshot.data!.exists.toString());
          if (snapshot.hasData) {
            if (snapshot.data!.exists) {
              printLog(snapshot.data!['name'].toString());
              return const DashBoard();
            } else {
              return const SetupProfileScreen();
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          // else if (snapshot.hasError) {
          //   return Scaffold(
          //     body: Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const Text("An unkown error occured"),
          //           ElevatedButton(
          //               onPressed: () {
          //                 setState(() {});
          //               },
          //               child: const Text('Reload'))
          //         ],
          //       ),
          //     ),
          //   );
          // }
          return const DashBoard();
        },
      );
    }
    return const LoginScreen();
  }
}
