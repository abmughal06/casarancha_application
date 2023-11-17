import 'dart:developer';
import 'dart:io';
import 'package:casarancha/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/post_model.dart';

import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/app_utils.dart';

class CreatePostMethods extends ChangeNotifier {
  late TextEditingController quoteTextController;
  late TextEditingController captionController;
  late TextEditingController tagsController;
  late TextEditingController locationController;

  CreatePostMethods() {
    quoteTextController = TextEditingController();
    captionController = TextEditingController();
    tagsController = TextEditingController();
    locationController = TextEditingController();
  }

  final fbinstance = FirebaseFirestore.instance;

  //Obserables
  var photosList = <File>[];
  var videosList = <File>[];
  var musicList = <File>[];
  var qouteList = <String>[];
  var mediaUploadTasks = <UploadTask>[];
  var mediaData = <MediaDetails>[];
  var isSharingPost = false;
  var question = '';
  var options = <Map>[];

  bool showPostTime = false;

  void togglePostTime() {
    showPostTime = !showPostTime;
    notifyListeners();
  }

  //Methods

  void clearLists() {
    photosList.clear();
    videosList.clear();
    musicList.clear();
    quoteTextController.clear();
    mediaUploadTasks.clear();
    mediaData.clear();
    captionController.clear();
    tagsController.clear();
    locationController.clear();
  }

  Future<void> sharePost(
      {String? groupId, UserModel? user, required bool isForum}) async {
    isSharingPost = true;
    notifyListeners();
    final postRef = groupId != null
        ? fbinstance.collection('groups').doc(groupId).collection('posts').doc()
        : fbinstance.collection('posts').doc();
    final userRef = fbinstance.collection('users').doc(user!.id);
    await postRef.set({});
    final postId = postRef.id;
    final creatorId = user.id;
    final creatorDetails = CreatorDetails(
      name: user.name,
      imageUrl: user.imageStr,
      isVerified: user.isVerified,
    );

    try {
      await uploadMediaFiles(postId: postId);

      final post = PostModel(
        id: postId,
        creatorId: creatorId,
        creatorDetails: creatorDetails,
        createdAt: DateTime.now().toUtc().toString(),
        description: captionController.text.trim(),
        locationName: locationController.text.trim(),
        tagsIds: tagsController.text.split(" ").map((e) => e).toList(),
        shareLink: '',
        videoViews: [],
        isForumPost: isForum,
        shareCount: [],
        showPostTime: showPostTime,
        mediaData: mediaData,
      );

      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data() ?? {});
      userModel.postsIds.add(postId);
      await userRef.update({"postsIds": userModel.postsIds});

      await postRef.set(post.toMap());
      Get.back();
      Get.back();
    } catch (e) {
      isSharingPost = false;
      notifyListeners();
      GlobalSnackBar(message: e.toString());
    } finally {
      isSharingPost = false;
      notifyListeners();
    }
  }

  Future<void> sharePollPost({
    UserModel? user,
  }) async {
    isSharingPost = true;
    notifyListeners();
    final forumRef = fbinstance.collection('posts').doc();
    final userRef = fbinstance.collection('users').doc(user!.id);
    await forumRef.set({});
    final postId = forumRef.id;
    final creatorId = user.id;
    final creatorDetails = CreatorDetails(
      name: user.name,
      imageUrl: user.imageStr,
      isVerified: user.isVerified,
    );

    try {
      final mediaDetails = MediaDetails(
        id: DateTime.now().toUtc().toString(),
        name: 'poll',
        type: 'poll',
        link: '',
        pollQuestion: question,
        pollOptions: options,
      );

      final post = PostModel(
        id: postId,
        creatorId: creatorId,
        creatorDetails: creatorDetails,
        createdAt: DateTime.now().toUtc().toString(),
        description: captionController.text.trim(),
        locationName: locationController.text.trim(),
        tagsIds: tagsController.text.split(" ").map((e) => e).toList(),
        shareLink: '',
        isForumPost: true,
        videoViews: [],
        shareCount: [],
        showPostTime: showPostTime,
        mediaData: [mediaDetails],
      );

      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data() ?? {});
      userModel.postsIds.add(postId);
      await userRef.update({"postsIds": userModel.postsIds});

      await forumRef.set(post.toMap());
      Get.back();
      Get.back();
    } catch (e) {
      isSharingPost = false;
      notifyListeners();
      GlobalSnackBar(message: e.toString());
    } finally {
      isSharingPost = false;
      notifyListeners();
    }
  }

  Future<void> uploadMediaFiles({required String postId}) async {
    final qouteText = quoteTextController.text.trim();

    if (qouteText.isNotEmpty) {
      mediaData.add(
        MediaDetails(
          id: DateTime.now().toUtc().toString(),
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

        final storageFileRef = storageRef.child('Posts/$postId/$fileName');

        storageFileRef.putFile(element);

        final uploadTask = storageFileRef.putData(await element.readAsBytes());

        mediaUploadTasks.add(uploadTask);
        notifyListeners();

        final mediaRef = await uploadTask.whenComplete(() {});

        final fileUrl = await mediaRef.ref.getDownloadURL();

        final MediaDetails mediaDetails;

        if (fileType == 'Photo') {
          mediaDetails = MediaDetails(
              id: DateTime.now().toUtc().toString(),
              name: fileName,
              type: fileType,
              link: fileUrl,
              imageHeight: imageSize?.height.toString(),
              imageWidth: imageSize?.width.toString());
        } else if (fileType == 'Video') {
          mediaDetails = MediaDetails(
              id: DateTime.now().toUtc().toString(),
              name: fileName,
              type: fileType,
              link: fileUrl,
              videoAspectRatio: videoAspectRatio?.toString());
        } else {
          mediaDetails = MediaDetails(
            id: DateTime.now().toUtc().toString(),
            name: fileName,
            type: fileType,
            link: fileUrl,
          );
        }

        mediaData.add(mediaDetails);
      }
    } on FirebaseException catch (e) {
      log("error 1  ${e.message}");

      GlobalSnackBar.show(message: e.toString());
    } on PlatformException catch (e) {
      log("error 2  ${e.message}");

      GlobalSnackBar.show(message: e.toString());
    }
  }

  Future<void> getPhoto() async {
    try {
      final pickedPhoto = await ImagePicker().pickMultiImage();
      // .pickImage(source: ImageSource.gallery);

      if (pickedPhoto.isNotEmpty) {
        // CroppedFile? croppedImage = await ImageCropper().cropImage(
        //     sourcePath: pickedPhoto.path,
        //     aspectRatio: const CropAspectRatio(ratioX: 2.0, ratioY: 3.0));
        // var image = File(croppedImage!.path);
        for (var i in pickedPhoto) {
          var image = File(i.path);
          photosList.add(image);
        }

        printLog(photosList.toString());
        notifyListeners();
      }
    } catch (e) {
      GlobalSnackBar.show(message: 'Operation Cancelled');
    }
  }

  void removePhotoFile(File photoFile) {
    photosList.remove(photoFile);
    notifyListeners();
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
    notifyListeners();
  }

  void removeVideoFile(File videoFile) {
    videosList.remove(videoFile);
    notifyListeners();
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
    notifyListeners();
  }

  void removeMusicFile(File musicFile) {
    musicList.remove(musicFile);
    notifyListeners();
  }

  @override
  void dispose() {
    quoteTextController.dispose();
    captionController.dispose();
    tagsController.dispose();
    locationController.dispose();
    photosList.clear();
    mediaData.clear();
    videosList.clear();
    musicList.clear();
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
