import 'dart:developer';
import 'dart:io';

import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

import '../../../models/ghost_message_details.dart';
import '../../../models/media_details.dart';
import '../../../models/user_model.dart';
import '../../../resources/firebase_cloud_messaging.dart';
import '../../home/CreatePost/create_post_controller.dart';

class ChatProvider extends ChangeNotifier {
//variables

  late TextEditingController messageController;
  ChatProvider() {
    messageController = TextEditingController();
    initRecorder();
  }

  final textFieldFocus = FocusNode();

  bool recoderStart = false;

  bool isExpanded = false;

//Observablaes
  var isChatExits = false;
  var isChecking = false;

  int unreadMessages = 0;

  final userRef = FirebaseFirestore.instance.collection("users");

  Future<void> sentMessage({UserModel? currentUser, UserModel? appUser}) async {
    if (messageController.text.isEmpty) {
      return;
    }
    try {
      final messageRefForCurrentUser = userRef
          .doc(currentUser!.id)
          .collection('messageList')
          .doc(appUser!.id)
          .collection('messages')
          .doc();

      final messageRefForAppUser = userRef
          .doc(appUser.id)
          .collection('messageList')
          .doc(currentUser.id)
          .collection('messages')
          .doc(
            messageRefForCurrentUser.id,
          );

      final MessageDetails appUserMessageDetails = MessageDetails(
        id: appUser.id,
        lastMessage: messageController.text,
        unreadMessageCount: 0,
        searchCharacters: [...appUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: appUser.name,
          imageUrl: appUser.imageStr,
          isVerified: appUser.isVerified,
        ),
        createdAt: DateTime.now().toIso8601String(),
      );

      final MessageDetails currentUserMessageDetails = MessageDetails(
        id: currentUser.id,
        lastMessage: messageController.text,
        unreadMessageCount: unreadMessages + 1,
        searchCharacters: [...currentUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: currentUser.name,
          imageUrl: currentUser.imageStr,
          isVerified: currentUser.isVerified,
        ),
        createdAt: DateTime.now().toIso8601String(),
      );

      // if (!isChatExits.value) {
      await userRef
          .doc(currentUser.id)
          .collection('messageList')
          .doc(appUser.id)
          .set(
            appUserMessageDetails.toMap(),
          );

      await userRef
          .doc(appUser.id)
          .collection('messageList')
          .doc(currentUser.id)
          .set(
            currentUserMessageDetails.toMap(),
          );

      final Message message = Message(
        id: messageRefForCurrentUser.id,
        sentToId: appUser.id,
        sentById: currentUser.id,
        content: messageController.text,
        caption: '',
        type: 'Text',
        createdAt: DateTime.now().toIso8601String(),
        isSeen: false,
      );

      final appUserMessage = message.copyWith(id: messageRefForAppUser.id);

      messageRefForCurrentUser.set(message.toMap());
      messageRefForAppUser.set(appUserMessage.toMap());

      // userRef
      //     .doc(appUser.id)
      //     .collection('messageList')
      //     .doc(currentUser.id)
      //     .update(
      //       currentUserMessageDetails.toMap(),
      //     );
      unreadMessages += 1;
      var recieverRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(appUser.id)
          .get();
      var recieverFCMToken = recieverRef.data()!['fcmToken'];
      FirebaseMessagingService().sendNotificationToUser(
        appUserId: recieverRef.id,
        devRegToken: recieverFCMToken,
        msg: "has sent you a $unreadMessages message",
      );

      messageController.clear();
      notifyListeners();
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }
  }

  Future<void> sentMessageGhost(
      {UserModel? currentUser,
      UserModel? appUser,
      bool? firstMessageByMe}) async {
    if (messageController.text.isEmpty) {
      return;
    }
    try {
      final messageRefForCurrentUser = userRef
          .doc(currentUser!.id)
          .collection('ghostMessageList')
          .doc(appUser!.id)
          .collection('messages')
          .doc();

      final messageRefForAppUser = userRef
          .doc(appUser.id)
          .collection('ghostMessageList')
          .doc(currentUser.id)
          .collection('messages')
          .doc(
            messageRefForCurrentUser.id,
          );

      final GhostMessageDetails appUserMessageDetails = GhostMessageDetails(
        id: appUser.id,
        lastMessage: messageController.text,
        firstMessage: firstMessageByMe! ? currentUser.id : appUser.id,
        unreadMessageCount: 0,
        searchCharacters: [...appUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: appUser.name,
          imageUrl: appUser.imageStr,
          isVerified: appUser.isVerified,
        ),
        createdAt: DateTime.now().toIso8601String(),
      );

      final GhostMessageDetails currentUserMessageDetails = GhostMessageDetails(
        id: currentUser.id,
        lastMessage: messageController.text,
        firstMessage: firstMessageByMe ? currentUser.id : appUser.id,
        unreadMessageCount: unreadMessages + 1,
        searchCharacters: [...currentUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: currentUser.name,
          imageUrl: currentUser.imageStr,
          isVerified: currentUser.isVerified,
        ),
        createdAt: DateTime.now().toIso8601String(),
      );

      // if (!isChatExits.value) {
      await userRef
          .doc(currentUser.id)
          .collection('ghostMessageList')
          .doc(appUser.id)
          .set(
            appUserMessageDetails.toMap(),
          );

      await userRef
          .doc(appUser.id)
          .collection('ghostMessageList')
          .doc(currentUser.id)
          .set(
            currentUserMessageDetails.toMap(),
          );

      // }

      final Message message = Message(
        id: messageRefForCurrentUser.id,
        sentToId: appUser.id,
        sentById: currentUser.id,
        content: messageController.text,
        caption: '',
        type: 'Text',
        createdAt: DateTime.now().toIso8601String(),
        isSeen: false,
      );

      final appUserMessage = message.copyWith(id: messageRefForAppUser.id);

      messageRefForCurrentUser.set(message.toMap());
      messageRefForAppUser.set(appUserMessage.toMap());

      // if (isChatExits.value) {
      userRef
          .doc(appUser.id)
          .collection('ghostMessageList')
          .doc(currentUser.id)
          .update(
            currentUserMessageDetails.toMap(),
          );
      unreadMessages += 1;
      // }
      var recieverRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(appUser.id)
          .get();
      var recieverFCMToken = recieverRef.data()!['fcmToken'];
      FirebaseMessagingService().sendNotificationToUser(
        appUserId: recieverRef.id,
        devRegToken: recieverFCMToken,
        msg: "has sent you a $unreadMessages message in ghost",
      );

      messageController.clear();
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }
  }

  Future<void> resetMessageCount({currentUserId, appUserId, messageid}) async {
    await userRef
        .doc(currentUserId)
        .collection('messageList')
        .doc(appUserId)
        .update({
      'unreadMessageCount': 0,
    });
    await userRef
        .doc(appUserId)
        .collection('messageList')
        .doc(currentUserId)
        .collection("messages")
        .doc(messageid)
        .update({
      'isSeen': true,
    });
  }

  Future<void> resetMessageCountGhost(
      {currentUserId, appUserId, messageid}) async {
    userRef
        .doc(currentUserId)
        .collection("ghostMessageList")
        .doc(appUserId)
        .update({
      'unreadMessageCount': 0,
    });
    await userRef
        .doc(appUserId)
        .collection('ghostMessageList')
        .doc(currentUserId)
        .collection("messages")
        .doc(messageid)
        .update({
      'isSeen': true,
    });
  }

  void clearMessageController() {
    messageController.clear();
    unreadMessages = 0;
  }

  var photosList = <File>[];
  var videosList = <File>[];
  var musicList = <File>[];
  var mediaList = <File>[];
  var mediaUploadTasks = <UploadTask>[];
  var mediaData = <MediaDetails>[];

  pickImageAndSentViaMessage(
      {UserModel? currentUser, UserModel? appUser, String? mediaType}) async {
    try {
      await uploadMediaFiles(recieverId: currentUser!.id);

      final messageRefForCurrentUser = userRef
          .doc(currentUser.id)
          .collection('messageList')
          .doc(appUser!.id)
          .collection('messages')
          .doc();

      final messageRefForAppUser = userRef
          .doc(appUser.id)
          .collection('messageList')
          .doc(currentUser.id)
          .collection('messages')
          .doc(
            messageRefForCurrentUser.id,
          );

      final MessageDetails appUserMessageDetails = MessageDetails(
        id: appUser.id,
        lastMessage: mediaType == 'InChatVideo'
            ? "Video"
            : mediaType == 'InChatPic'
                ? "Photo"
                : mediaType == 'InChatDoc'
                    ? "Doc"
                    : 'Music',
        unreadMessageCount: 0,
        searchCharacters: [...appUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: appUser.name,
          imageUrl: appUser.imageStr,
          isVerified: appUser.isVerified,
        ),
        createdAt: DateTime.now().toIso8601String(),
      );

      final MessageDetails currentUserMessageDetails = MessageDetails(
        id: currentUser.id,
        lastMessage: mediaType == 'InChatVideo'
            ? "Video"
            : mediaType == 'InChatPic'
                ? "Photo"
                : mediaType == 'InChatDoc'
                    ? "Doc"
                    : 'Music',
        unreadMessageCount: unreadMessages + 1,
        searchCharacters: [...currentUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: currentUser.name,
          imageUrl: currentUser.imageStr,
          isVerified: currentUser.isVerified,
        ),
        createdAt: DateTime.now().toIso8601String(),
      );

      // if (!isChatExits.value) {
      await userRef
          .doc(currentUser.id)
          .collection('messageList')
          .doc(appUser.id)
          .set(
            appUserMessageDetails.toMap(),
          );

      await userRef
          .doc(appUser.id)
          .collection('messageList')
          .doc(currentUser.id)
          .set(
            currentUserMessageDetails.toMap(),
          );

      final Message message = Message(
        id: messageRefForCurrentUser.id,
        sentToId: appUser.id,
        sentById: currentUser.id,
        content: mediaData.map((e) => e.toMap()).toList(),
        caption: '',
        type: '$mediaType',
        createdAt: DateTime.now().toIso8601String(),
        isSeen: false,
      );
      // log(message.toString());

      final appUserMessage = message.copyWith(id: messageRefForAppUser.id);

      messageRefForCurrentUser.set(message.toMap());
      messageRefForAppUser.set(appUserMessage.toMap());

      // userRef
      //     .doc(appUser.id)
      //     .collection('messageList')
      //     .doc(currentUser.id)
      //     .update(
      //       currentUserMessageDetails.toMap(),
      //     );
      unreadMessages += 1;
      var recieverRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(appUser.id)
          .get();
      var recieverFCMToken = recieverRef.data()!['fcmToken'];
      FirebaseMessagingService().sendNotificationToUser(
        appUserId: recieverRef.id,
        devRegToken: recieverFCMToken,
        msg: "has sent you a $unreadMessages message",
      );
      clearLists();

      // messageController.clear();
    } catch (e) {
      log(e.toString());
    }
  }

  void clearLists() {
    photosList.clear();
    videosList.clear();
    musicList.clear();
    mediaList.clear();
    mediaUploadTasks.clear();
    tasksProgress = 0.0;
    mediaData.clear();
    notifyListeners();
  }

  void clearListsondispose() {
    photosList.clear();
    videosList.clear();
    musicList.clear();
    mediaList.clear();
    mediaUploadTasks.clear();
    mediaData.clear();
  }

  double tasksProgress = 0.0;

  Future<void> uploadMediaFiles({required String recieverId}) async {
    final allMediaFiles = [
      ...photosList,
      ...videosList,
      ...musicList,
      ...mediaList
    ];

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
        } else if (mediaList.contains(element)) {
          fileType = 'Media';
        } else {
          fileType = 'Music';
        }

        final storageFileRef = storageRef.child('Chats/$recieverId/$fileName');

        storageFileRef.putFile(element);

        final uploadTask = storageFileRef.putData(await element.readAsBytes());

        mediaUploadTasks.add(uploadTask);
        notifyListeners();

        for (var i in mediaUploadTasks) {
          tasksProgress += i.snapshot.bytesTransferred / i.snapshot.totalBytes;
          notifyListeners();
        }
        tasksProgress = tasksProgress / mediaUploadTasks.length;
        notifyListeners();

        final mediaRef = await uploadTask.whenComplete(() {});

        final fileUrl = await mediaRef.ref.getDownloadURL();

        final MediaDetails mediaDetails;

        if (fileType == 'Photo') {
          mediaDetails = MediaDetails(
              id: DateTime.now().toIso8601String(),
              name: fileName,
              type: fileType,
              link: fileUrl,
              imageHeight: imageSize?.height.toString(),
              imageWidth: imageSize?.width.toString());
        } else if (fileType == 'Video') {
          mediaDetails = MediaDetails(
              id: DateTime.now().toIso8601String(),
              name: fileName,
              type: fileType,
              link: fileUrl,
              videoAspectRatio: videoAspectRatio?.toString());
        } else if (fileType == 'Media') {
          mediaDetails = MediaDetails(
              id: DateTime.now().toIso8601String(),
              name: fileName,
              type: fileType,
              link: fileUrl);
        } else {
          mediaDetails = MediaDetails(
            id: DateTime.now().toIso8601String(),
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
      final pickedPhoto =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedPhoto != null) {
        CroppedFile? croppedImage = await ImageCropper().cropImage(
            sourcePath: pickedPhoto.path,
            aspectRatio: const CropAspectRatio(ratioX: 2.0, ratioY: 3.0));
        var image = File(croppedImage!.path);

        photosList.add(image);
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
      // log(videosList.toString());
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

  Future<void> getMedia() async {
    final List<File> mediaFilesHelper = [];
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      for (var element in result!.files) {
        log('========>>>>>');
        mediaFilesHelper.add(File(element.path ?? ''));
      }

      mediaList.assignAll(mediaFilesHelper);
      log(mediaList.toString());
    } catch (e) {
      GlobalSnackBar.show(message: 'Operation Cancelled');
    }
    notifyListeners();
  }

  void removeMediaFile(File mediaFile) {
    mediaList.remove(mediaFile);
    notifyListeners();
  }

  Future openDocFile({String? path}) async {
    OpenFile.open(path);
  }

  void notifyUI() {
    notifyListeners();
  }

  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  String? path;

  // // final audioPlayer = audio.AudioPlayer();
  // bool isPlaying = false;
  // Duration duration = Duration.zero;
  // Duration position = Duration.zero;
  File? voiceFile;

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop(context) async {
    // final registerController =
    //     Provider.of<RegisterController>(context, listen: false);
    // if (!isRecorderReady) return;
    path = await recorder.stopRecorder();
    log(path!);
    final audioFile = File(path!);
    voiceFile = audioFile;
    notifyListeners();

    log('================== Recorded audio: ${audioFile.path}');
  }

  // bool? _showIntro;

  clearVoiceFile() {
    voiceFile = null;
    notifyListeners();
  }

  Future initRecorder() async {
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    super.dispose();
    recorder.closeRecorder();
  }
}
