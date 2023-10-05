import 'dart:developer';

import 'package:casarancha/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../resources/color_resources.dart';

FirebaseFirestore get firestore => FirebaseFirestore.instance;
Widget menuUserButton(
  context,
  String userId,
  String name, {
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
}) {
  return PopupMenuButton<String>(
    offset: const Offset(0, -8),
    onSelected: (value) async {
      switch (value) {
        case 'Open_Dialog':
          if (FirebaseAuth.instance.currentUser?.uid != null) {
            await reportUserDialog(context, userId: userId, user: name);
          }
          break;

        default:
          throw UnimplementedError();
      }
    },
    position: PopupMenuPosition.under,
    child: Container(
        alignment: Alignment.center,
        padding: padding ?? const EdgeInsets.all(4),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0.5, 0.5),
                  spreadRadius: 1.5,
                  blurRadius: 1.5,
                  color: Colors.black12)
            ],
            shape: BoxShape.circle),
        child: const Icon(
          Icons.more_horiz,
          size: 25,
          color: Colors.black,
        )),
    itemBuilder: (context) {
      return [
        const PopupMenuItem(
          value: "Open_Dialog",
          height: kMinInteractiveDimension / 1.8,
          child: Text(
            "Report user",
            style: TextStyle(color: colorPrimaryA05),
          ),
        )
      ];
    },
  );
}

Future<bool?> reportUser(String userId, String reporterUserId) async {
  try {
    DocumentSnapshot docSnapshot = await firestore
        .collection("reportUser")
        .doc("${userId}_$reporterUserId")
        .get();
    if (!docSnapshot.exists) {
      DocumentReference reportDocRef = docSnapshot.reference;
      await reportDocRef.set({
        "objId": reportDocRef.id,
        "reporterUserId": reporterUserId,
        "userId": userId,
        "createAt": DateTime.now().toIso8601String()
      });
      return true;
    } else {
      return false;
    }
  } catch (e) {
    log("error in reportUser => $e");
  }
  return null;
}

Future<bool?> addUserReportCount(String userId, String reporterUserId) async {
  bool? reportSuccess;
  try {
    reportSuccess = await reportUser(userId, reporterUserId);
    if (reportSuccess == true) {
      DocumentSnapshot<Map<String, dynamic>> docSnap =
          await firestore.collection("users").doc(userId).get();
      UserModel user = UserModel.fromMap(docSnap.data() ?? {});
      DocumentReference userRef = docSnap.reference;
      await userRef.set({"reportCount": (user.reportCount ?? 0) + 1},
          SetOptions(merge: true));
      if ((user.reportCount ?? 0) + 1 > 10) {
        firestore
            .collection("posts")
            .where("creatorId", isEqualTo: userId)
            .get()
            .then((value) async {
          var batch = firestore.batch();
          for (var element in value.docs.where(
              (element) => element.data()['postBlockStatus'] != 'Blocked')) {
            batch.set(element.reference, {"postBlockStatus": "Blocked"},
                SetOptions(merge: true));
          }
          await batch.commit();
        });
      }
    }
  } catch (e) {
    log("error in addUserReportCount => $e");
  }
  return reportSuccess;
}

thanksForUserReportDialog(context, String user) async {
  await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Thanks for report!"),
          content: Text(
              "Support team will take action as soon as possible on this $user."),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Back"))
          ],
        );
      });
}

alreadyUserReportDialog(context, String user) async {
  await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Report already submitted"),
          content: Text(
              "Report already submitted! Support team will take action as soon as possible on this $user."),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Back"))
          ],
        );
      });
}

reportUserDialog(context,
    {required String userId, required String user}) async {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid != null) {
    await showDialog(
        context: context,
        builder: (context) {
          bool isLoading = false;
          return StatefulBuilder(builder: (context, setState) {
            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: colorPrimaryA05))
                : CupertinoAlertDialog(
                    title: const Text("Report user!"),
                    content:
                        Text("Are you sure you want to report this $user?"),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            bool? reportSuccess =
                                await addUserReportCount(userId, uid);
                            setState(() {
                              isLoading = false;
                            });
                            if (reportSuccess == true) {
                              Get.back();
                              // ignore: use_build_context_synchronously
                              thanksForUserReportDialog(context, user);
                            } else if (reportSuccess == false) {
                              Get.back();
                              // ignore: use_build_context_synchronously
                              alreadyUserReportDialog(context, user);
                            }
                          },
                          child: const Text(
                            "Report",
                            style: TextStyle(color: colorPrimaryA05),
                          )),
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: colorBlack),
                          ))
                    ],
                  );
          });
        });
  }
}
