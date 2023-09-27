import 'dart:io';

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
    isCreating = true;
    notifyListeners();
    var groupName = gName;
    var groupDescription = bio;
    if (groupName.isEmpty) {
      const GlobalSnackBar(message: 'Please write group name');
      return;
    }
    if (groupDescription.isEmpty) {
      const GlobalSnackBar(message: 'Please write group description');
      return;
    }
    if (imageFilePicked == null) {
      const GlobalSnackBar(message: 'Please provide group image');
      return;
    }

    final groupRef = FirebaseFirestore.instance.collection('groups').doc();

    final ref =
        FirebaseStorage.instance.ref().child('groupImages/${groupRef.id}');

    try {
      final imageRef = await ref.putFile(imageFilePicked!).whenComplete(() {});

      final imageUrl = await imageRef.ref.getDownloadURL();

      final GroupModel group = GroupModel(
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
        createdAt: DateTime.now().toIso8601String(),
        isPublic: isPublic,
        memberIds: membersIds,
        joinRequestIds: [],
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
}
