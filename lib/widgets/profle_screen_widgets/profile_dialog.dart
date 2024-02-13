import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../resources/color_resources.dart';
import '../../screens/auth/login_screen.dart';

deleteAccountDialog(context) {
  TextButton cancelBtn = TextButton(
      onPressed: () => Get.back(),
      child: const Text("Cancel", style: TextStyle(color: color229)));

  Text desc = Text("Are you sure you want to delete your account?",
      style: TextStyle(
          color: Colors.black, fontSize: 16.w, fontWeight: FontWeight.w500));
  Text title = Text("DELETE ACCOUNT",
      style: TextStyle(
          color: colorPrimaryA05, fontSize: 18.w, fontWeight: FontWeight.w700));
  // TextEditingController passwordText = TextEditingController();
  bool isLoading = false;
  return StatefulBuilder(builder: (context, setState) {
    return isLoading
        ? Center(
            child: Container(
            height: 80,
            width: 80,
            color: Colors.white.withOpacity(0.7),
            alignment: Alignment.center,
            child: const Card(
              elevation: 0,
              color: Colors.transparent,
              child: CircularProgressIndicator(
                color: colorPrimaryA05,
              ),
            ),
          ))
        : Center(
            child: Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: dialog(
                  title: title,
                  content: desc,
                  actions: [
                    TextButton(
                        onPressed: () async {
                          if (FirebaseAuth.instance.currentUser != null) {
                            setState(() {
                              isLoading = true;
                            });
                            // await deleteAccountFromId(
                            //     FirebaseAuth.instance.currentUser!);
                            // Get.back();
                            // Get.back();
                            // Get.off(() => const LoginScreen());
                            // setState(() {
                            //   isLoading = false;
                            // });
                          }
                        },
                        child: Text(appText(context).strOk,
                            style: const TextStyle(color: colorPrimaryA05))),
                    cancelBtn
                  ],
                ),
              ),
            ),
          );
  });
}

dialog(
    {Widget? title, Widget? content, List<Widget> actions = const <Widget>[]}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Align(alignment: Alignment.center, child: title),
      const SizedBox(height: 5),
      Align(alignment: Alignment.center, child: content),
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions.map((e) => e).toList(),
      )
    ],
  );
}

userUserIsNotMatched(
    context, FirebaseAuth auth, UserCredential? credential) async {
  if (credential != null) {
    User? user = credential.user;
    if (user != null) {
      if (user.uid == auth.currentUser?.uid) {
        // await deleteAccountFromId(user);
        Get.back();
        Get.back();
        Get.off(() => const LoginScreen());
      } else {
        Get.back();
        showDialogUserIsNotMatched(context);
      }
    } else {
      Get.back();
      showDialogUserIsNotMatched(context);
    }
  } else {
    Get.back();
    showDialogUserIsNotMatched(context);
  }
}

void showDialogUserIsNotMatched(context) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(appText(context).strUserNotMatched),
          actions: [
            TextButton(
                onPressed: () => Get.back(),
                child: Text(appText(context).strOk))
          ],
        );
      });
}
