import 'dart:io';
import 'package:casarancha/models/user_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/post_model.dart';

import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CreatePostController extends GetxController {
  late TextEditingController quoteTextController;
  late TextEditingController captionController;
  late TextEditingController tagsController;
  late TextEditingController locationController;

  late ProfileScreenController profileScreenController;

  final fbinstance = FirebaseFirestore.instance;

  //Obserables
  var photosList = <File>[].obs;
  var videosList = <File>[].obs;
  var musicList = <File>[].obs;
  var qouteList = <String>[].obs;

  var mediaUploadTasks = <UploadTask>[].obs;

  var mediaData = <MediaDetails>[].obs;

  var isSharingPost = false.obs;

  //Methods

  Future<void> sharePost({String? groupId, bool showPostTime = true}) async {
    isSharingPost.value = true;
    final postRef = groupId != null
        ? fbinstance.collection('groups').doc(groupId).collection('posts').doc()
        : fbinstance.collection('posts').doc();
    final userRef = fbinstance
        .collection('users')
        .doc(profileScreenController.user.value.id);
    await postRef.set({});
    final postId = postRef.id;
    final creatorId = profileScreenController.user.value.id;
    final creatorDetails = CreatorDetails(
      name: profileScreenController.user.value.name,
      imageUrl: profileScreenController.user.value.imageStr,
      isVerified: profileScreenController.user.value.isVerified,
    );
    try {
      await uploadMediaFiles(postId: postId);
      final post = PostModel(
        id: postId,
        creatorId: creatorId,
        creatorDetails: creatorDetails,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        description: captionController.text.trim(),
        locationName: locationController.text.trim(),
        shareLink: '',
        showPostTime: showPostTime,
        mediaData: mediaData,
      );

      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data() ?? {});
      userModel.postsIds.add(postId);
      await userRef.update({"postsIds": userModel.postsIds});

      profileScreenController.user.value = userModel;

      await postRef.set(post.toMap());
      Get.back();
      Get.back();
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }
    isSharingPost.value = false;
  }

  Future<void> uploadMediaFiles({required String postId}) async {
    final qouteText = quoteTextController.text.trim();

    if (qouteText.isNotEmpty) {
      mediaData.add(
        MediaDetails(
          id: DateTime.now().toUtc().toIso8601String(),
          name: 'Nothing',
          type: 'Qoute',
          link: qouteText,
        ),
      );
    }

    final allMediaFiles = [...photosList, ...videosList, ...musicList];

    final storageRef = FirebaseStorage.instance.ref();

    try {
      for (var element in allMediaFiles) {
        final String fileType;
        final String fileName = basename(element.path);
        Size? imageSize;
        double? videoAspectRatio;

        if (photosList.contains(element)) {
          fileType = 'Photo';
          imageSize = await getImageSize(element);
        } else if (videosList.contains(element)) {
          fileType = 'Video';
          videoAspectRatio = await getVideoAspectRatio(element);
        } else {
          fileType = 'Music';
        }
/* 
File image = new File('image.png'); // Or any other way to get a File instance.
var decodedImage = await decodeImageFromList(image.readAsBytesSync());
print(decodedImage.width);
print(decodedImage.height);
 */
        final storageFileRef = storageRef.child('Posts/$postId/$fileName');

        final uploadTask = storageFileRef.putFile(element);
        mediaUploadTasks.add(uploadTask);
        final mediaRef = await uploadTask.whenComplete(() {});
        final fileUrl = await mediaRef.ref.getDownloadURL();
        final MediaDetails mediaDetails;
        if (fileType == 'Photo') {
          mediaDetails = MediaDetails(
              id: DateTime.now().toUtc().toIso8601String(),
              name: fileName,
              type: fileType,
              link: fileUrl,
              imageHeight: imageSize?.height.toString(),
              imageWidth: imageSize?.width.toString());
        } else if (fileType == 'Video') {
          mediaDetails = MediaDetails(
              id: DateTime.now().toUtc().toIso8601String(),
              name: fileName,
              type: fileType,
              link: fileUrl,
              videoAspectRatio: videoAspectRatio?.toString());
        } else {
          mediaDetails = MediaDetails(
            id: DateTime.now().toUtc().toIso8601String(),
            name: fileName,
            type: fileType,
            link: fileUrl,
          );
        }
        mediaData.add(mediaDetails);
      }
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }
  }

  Future<void> getPhoto() async {
    try {
      final pickedPhoto =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedPhoto != null) {
        CroppedFile? croppedImage = await ImageCropper().cropImage(
            sourcePath: pickedPhoto.path,
            aspectRatio: const CropAspectRatio(ratioX: 2.0, ratioY: 3.0));
        var image = File(croppedImage!.path);

        photosList.add(image);
      }
    } catch (e) {
      GlobalSnackBar.show(message: 'Operation Cancelled');
    }
  }

  void removePhotoFile(File photoFile) {
    photosList.remove(photoFile);
  }

  Future<void> getVideo() async {
    final File videoFileHelper;
    try {
      final pickedVideo = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );
      videoFileHelper = File(pickedVideo!.path);
      videosList.add(videoFileHelper);
    } catch (e) {
      GlobalSnackBar.show(message: 'Operation Cancelled');
    }
  }

  void removeVideoFile(File videoFile) {
    videosList.remove(videoFile);
  }

  Future<void> getMusic() async {
    final List<File> musiciFilesHelper = [];
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.audio,
      );
      for (var element in result!.files) {
        musiciFilesHelper.add(File(element.path ?? ''));
      }

      musicList.assignAll(musiciFilesHelper);
    } catch (e) {
      GlobalSnackBar.show(message: 'Operation Cancelled');
    }
  }

  void removeMusicFile(File musicFile) {
    musicList.remove(musicFile);
  }

  //OverRides
  @override
  void onInit() {
    quoteTextController = TextEditingController();
    captionController = TextEditingController();
    tagsController = TextEditingController();
    locationController = TextEditingController();

    profileScreenController = Get.find<ProfileScreenController>();
    super.onInit();
  }

  @override
  void dispose() {
    // quoteTextController.dispose();
    captionController.dispose();
    tagsController.dispose();
    locationController.dispose();
    super.dispose();
  }
}

Future<Size> getImageSize(File image) async {
  var decodedImage = await decodeImageFromList(image.readAsBytesSync());
  return Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
}

Future<double> getVideoAspectRatio(File video) async {
  VideoPlayerController videoPlayerController =
      VideoPlayerController.file(video);
  await videoPlayerController.initialize();
  return videoPlayerController.value.aspectRatio;
}

Future<File?> profileCropImage(String path) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: path,
    aspectRatioPresets: [
      CropAspectRatioPreset.ratio16x9,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio5x3,
      CropAspectRatioPreset.ratio5x4,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.original,
    ],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.white,
      ),
      IOSUiSettings(
        title: 'Cropper',
        resetAspectRatioEnabled: true,
      ),
    ],
  );
  if (croppedFile != null) {
    return File(croppedFile.path);
  } else {
    return null;
  }
}

Future<File?> cropImage(String path) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.original
    ],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
      ),
      IOSUiSettings(
          title: 'Cropper',
          resetAspectRatioEnabled: true,
          aspectRatioLockEnabled: true),
    ],
  );
  if (croppedFile != null) {
    return File(croppedFile.path);
  } else {
    return null;
  }
}
