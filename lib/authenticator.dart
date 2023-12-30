import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/auth/setup_profile_details.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

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
          // printLog(currentUserUID);

          if (snapshot.hasData) {
            if (snapshot.data!.exists) {
              // printLog(snapshot.data!['name'].toString());
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
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("An unkown error occured"),
                    ElevatedButton(
                      onPressed: () {
                        // setState(() {});
                      },
                      child: const Text('Reload'),
                    )
                  ],
                ),
              ),
            );
          }
          return const SetupProfileScreen();
        },
      );
    }
    return const LoginScreen();
  }
}
