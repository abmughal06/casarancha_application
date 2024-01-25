import 'dart:io';

import 'package:casarancha/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/group_model.dart';
import '../../../models/post_creator_details.dart';
import '../../../models/user_model.dart';
import '../../../utils/snackbar.dart';

class NewGroupProvider extends ChangeNotifier {
  File? imageFilePicked;
  bool isCreating = false;

  getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 400,
      maxHeight: 400,
    );
    if (pickedFile != null) {
      imageFilePicked = File(pickedFile.path);
      notifyListeners();
    } else {
      GlobalSnackBar.show(message: 'Process Cancelled');
    }
  }

  createGroup(
      {required String gName,
      required String bio,
      required bool isPublic,
      required UserModel currentUser,
      required List<String> membersIds}) async {
    try {
      isCreating = true;
      notifyListeners();
      var groupName = gName;
      var groupDescription = bio;
      if (groupName.isEmpty) {
        GlobalSnackBar.show(message: 'Please write group name');
        return;
      }
      if (groupDescription.isEmpty) {
        GlobalSnackBar.show(message: 'Please write group description');
        return;
      }
      if (imageFilePicked == null) {
        GlobalSnackBar.show(message: 'Please provide group image');
        return;
      }

      final groupRef = FirebaseFirestore.instance.collection('groups').doc();

      final ref =
          FirebaseStorage.instance.ref().child('groupImages/${groupRef.id}');
      final imageRef = await ref.putFile(imageFilePicked!).whenComplete(() {});

      final imageUrl = await imageRef.ref.getDownloadURL();

      final GroupModel group = GroupModel(
        isVerified: false,
        id: groupRef.id,
        name: groupName,
        description: groupDescription,
        imageUrl: imageUrl,
        creatorId: currentUser.id,
        creatorDetails: CreatorDetails(
          name: currentUser.name,
          imageUrl: currentUser.imageStr,
          isVerified: currentUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
        isPublic: isPublic,
        memberIds: membersIds,
        joinRequestIds: [],
        adminIds: [currentUser.id],
      );

      await groupRef.set(group.toMap());
      Get.back();
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    } finally {
      isCreating = false;
      notifyListeners();
    }
  }

  addGroupMembers({id, groupId}) async {
    try {
      await FirebaseFirestore.instance.collection('groups').doc(groupId).update(
        {
          'memberIds': FieldValue.arrayUnion([id])
        },
      );
    } catch (e) {
      printLog(e.toString());
    } finally {
      notifyListeners();
    }
  }

  addGroupAdmins({id, groupId}) async {
    try {
      await FirebaseFirestore.instance.collection('groups').doc(groupId).update(
        {
          'adminIds': FieldValue.arrayUnion([id])
        },
      );
    } catch (e) {
      printLog(e.toString());
    } finally {
      notifyListeners();
    }
  }

  banUserFromGroup({id, groupId}) async {
    try {
      await FirebaseFirestore.instance.collection('groups').doc(groupId).update(
        {
          'banUsersIds': FieldValue.arrayUnion([id]),
          'memberIds': FieldValue.arrayRemove([id]),
        },
      );
    } catch (e) {
      printLog(e.toString());
    } finally {
      notifyListeners();
    }
  }

  unBanUserFromGroup({id, groupId}) async {
    try {
      await FirebaseFirestore.instance.collection('groups').doc(groupId).update(
        {
          'banUsersIds': FieldValue.arrayRemove([id])
        },
      );
    } catch (e) {
      printLog(e.toString());
    } finally {
      notifyListeners();
    }
  }

  togglePrivate({isPublic, groupId}) async {
    try {
      await FirebaseFirestore.instance.collection('groups').doc(groupId).update(
        {
          'isPublic': !isPublic,
        },
      );
    } catch (e) {
      printLog(e.toString());
    } finally {
      notifyListeners();
    }
  }

  removeGroupMembers({id, groupId}) async {
    try {
      await FirebaseFirestore.instance.collection('groups').doc(groupId).update(
        {
          'memberIds': FieldValue.arrayRemove([id])
        },
      );
    } catch (e) {
      printLog(e.toString());
    } finally {
      notifyListeners();
    }
  }

  banUserFromComments({id, groupId}) async {
    try {
      await FirebaseFirestore.instance.collection('groups').doc(groupId).update(
        {
          'banFromCmntUsersIds': FieldValue.arrayUnion([id])
        },
      );
    } catch (e) {
      printLog(e.toString());
    } finally {
      notifyListeners();
    }
  }

  unBanUserFromComments({id, groupId}) async {
    try {
      await FirebaseFirestore.instance.collection('groups').doc(groupId).update(
        {
          'banFromCmntUsersIds': FieldValue.arrayRemove([id])
        },
      );
    } catch (e) {
      printLog(e.toString());
    } finally {
      notifyListeners();
    }
  }

  deleteGroup(groupId) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .delete();
    } catch (e) {
      printLog(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
