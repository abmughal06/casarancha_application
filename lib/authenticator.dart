import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/auth/setup_profile_details.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser == null) {
      return const LoginScreen();
    } else {
      return Consumer<UserModel?>(
        builder: (context, user, child) {
          if (user == null) {
            return Scaffold(
              body: centerLoader(),
            );
          } else if (user.name.isEmpty || user.username.isEmpty) {
            return const SetupProfileScreen();
          } else {
            return const DashBoard();
          }
        },
      );
    }
  }
}
