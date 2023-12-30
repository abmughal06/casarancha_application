import 'dart:io';

import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/user_model.dart';

class AddStoryProvider extends ChangeNotifier {
  // late ProfileScreenController profileScreenController;

  final fbinstance = FirebaseFirestore.instance;

  //Obserables

  UploadTask? mediaUploadTasks;
  File? mediaFile;

  var mediaData = MediaDetails(id: '', name: '', type: '', link: '');

  var isSharingStory = false;

  //Methods

  Future<void> shareStory({UserModel? user}) async {
    if (mediaFile == null) {
      GlobalSnackBar.show(message: 'Please add a Photo or Video');
      return;
    }
    isSharingStory = true;
    notifyListeners();
    final creatorId = user!.id;

    final storyRef = fbinstance.collection('stories').doc(creatorId);
    final mediaRef = fbinstance
        .collection('stories')
        .doc(creatorId)
        .collection('media')
        .doc();
    final userRef = fbinstance.collection('users').doc(creatorId);
    final storyId = storyRef.id;

    final creatorDetails = CreatorDetails(
      name: user.name,
      imageUrl: user.imageStr,
      isVerified: user.isVerified,
    );
    try {
      await uploadMediaFiles(storyId: storyId);

      final storyData = await storyRef.get();

      if (storyData.exists) {
        await storyRef.update({
          'mediaDetailsList': FieldValue.arrayUnion([
            mediaData.toMap(),
          ])
        });
      } else {
        final story = Story(
          id: storyId,
          storyViews: [],
          creatorId: creatorId,
          creatorDetails: creatorDetails,
          createdAt: DateTime.now().toIso8601String(),
          mediaDetailsList: [],
        );

        await userRef.update({
          'storiesIds': FieldValue.arrayUnion([storyId])
        });

        await storyRef.set(story.toMap());
        await mediaRef.set(mediaData.toMap());
      }

      Get.back();
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }
    isSharingStory = false;
    notifyListeners();
  }

  Future<void> uploadMediaFiles({required String storyId}) async {
    final storageRef = FirebaseStorage.instance.ref();

    try {
      final String fileType = mediaData.type;
      final String fileName = basename(mediaFile!.path);
      final storageFileRef = storageRef.child('stories/$storyId/$fileName');
      final uploadTask = storageFileRef.putData(await mediaFile!.readAsBytes());
      mediaUploadTasks = uploadTask;
      final mediaRef = await uploadTask.whenComplete(() {});
      final fileUrl = await mediaRef.ref.getDownloadURL();
      final mediaDetails = MediaDetails(
        id: DateTime.now().toIso8601String(),
        name: fileName,
        type: fileType,
        link: fileUrl,
      );
      mediaData = mediaDetails;
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }
  }

  Future<void> getMedia({required String type}) async {
    try {
      if (type == 'Photo') {
        final pickedmedia = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
        mediaData.type = type;

        mediaFile = File(pickedmedia!.path);
      } else {
        final pickedmedia = await ImagePicker().pickVideo(
          source: ImageSource.gallery,
        );
        mediaData.type = type;
        mediaFile = File(pickedmedia!.path);
      }
    } catch (e) {
      GlobalSnackBar.show(message: 'Operation Cancelled');
    }
    notifyListeners();
  }

  void removeMedia() {
    mediaFile = null;
    notifyListeners();
  }

  void disposeMedia() {
    mediaFile = null;
  }
}
