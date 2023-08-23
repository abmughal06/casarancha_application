import 'dart:developer';
import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../models/ghost_message_details.dart';
import '../../../models/media_details.dart';
import '../../../models/user_model.dart';
import '../../../resources/firebase_cloud_messaging.dart';
import '../../home/CreatePost/create_post_controller.dart';

class ChatProvider extends ChangeNotifier {
//variables

  late TextEditingController messageController;
  late Record audioRecorder;
  ChatProvider() {
    messageController = TextEditingController();
    audioRecorder = Record();
  }

  final textFieldFocus = FocusNode();

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
  var voiceList = <File>[];
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

      unreadMessages += 1;
      var recieverRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(appUser.id)
          .get();
      var recieverFCMToken = recieverRef.data()!['fcmToken'];
      FirebaseMessagingService().sendNotificationToUser(
        appUserId: recieverRef.id,
        devRegToken: recieverFCMToken,
        msg: "has sent you a $unreadMessages attachment",
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
    voiceList.clear();
    mediaUploadTasks.clear();
    tasksProgress = 0.0;
    mediaData.clear();
    recordedFilePath = null;
    voiceUrl = null;
    notifyListeners();
  }

  void clearListsondispose() {
    photosList.clear();
    videosList.clear();
    musicList.clear();
    mediaUploadTasks.clear();
    mediaData.clear();
  }

  double tasksProgress = 0.0;

  Future<void> uploadMediaFiles({required String recieverId}) async {
    final allMediaFiles = [
      ...photosList,
      ...videosList,
      ...musicList,
      ...voiceList,
    ];

    log(allMediaFiles.toString());

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
        } else if (musicList.contains(element)) {
          fileType = 'Music';
        } else {
          fileType = 'voice';
        }

        final storageFileRef =
            storageRef.child('Chats/$recieverId/$fileType/$fileName');

        await storageFileRef.putFile(element);

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

  void notifyUI() {
    notifyListeners();
  }

  bool isRecording = false;
  File? recordedFilePath;
  String? voiceUrl;

  startRecording() async {
    final String filename =
        '${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v4()}';

    log(filename);
    if (await audioRecorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      await audioRecorder.start(
        path: "${dir.path}/$filename.m4a",
      );
      isRecording = true;
      notifyListeners();
    }
  }

  stopRecording({UserModel? currentUser, UserModel? appUser}) async {
    try {
      String? path = await audioRecorder.stop();
      if (path == null) {
        // Handle the case where recording didn't produce a valid path
        return;
      }

      isRecording = false;
      recordedFilePath = File(path);

      voiceList.add(recordedFilePath!);

      log(voiceList.toString());

      if (voiceList.isEmpty) {
        return;
      }
      await sendVoiceMessage(currentUser: currentUser, appUser: appUser);
    } catch (e) {
      log('Error: $e');
    } finally {
      notifyListeners();
    }
  }

  sendVoiceMessage({UserModel? currentUser, UserModel? appUser}) async {
    try {
      await uploadMediaFiles(recieverId: appUser!.id);

      log('done');

      final messageRefForCurrentUser = userRef
          .doc(currentUser!.id)
          .collection('messageList')
          .doc(appUser.id)
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
        lastMessage: 'voice message',
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
        lastMessage: 'voice message',
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

      // log(mediaData.toString());

      final Message message = Message(
        id: messageRefForCurrentUser.id,
        sentToId: appUser.id,
        sentById: currentUser.id,
        content: mediaData.map((e) => e.toMap()).toList(),
        caption: '',
        type: 'voice',
        createdAt: DateTime.now().toIso8601String(),
        isSeen: false,
      );
      // log(message.toString());

      final appUserMessage = message.copyWith(id: messageRefForAppUser.id);

      messageRefForCurrentUser.set(message.toMap());
      messageRefForAppUser.set(appUserMessage.toMap());

      unreadMessages += 1;
      var recieverRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(appUser.id)
          .get();
      var recieverFCMToken = recieverRef.data()!['fcmToken'];
      FirebaseMessagingService().sendNotificationToUser(
        appUserId: recieverRef.id,
        devRegToken: recieverFCMToken,
        msg: "has sent you a $unreadMessages voice message",
      );

      clearLists();

      // messageController.clear();
    } catch (e) {
      log(e.toString());
    }
  }

  // Future<void> uploadVoice({required String recieverId}) async {
  //   final storageRef = FirebaseStorage.instance.ref();
  //   try {
  //     final element = recordedFilePath!;

  //     log(element.toString());

  //     final String fileName = basename(element.path.split('/').last);

  //     log('before setting $fileName');

  //     final storageFileRef = storageRef.child('Chats/$recieverId/$fileName');

  //     log('after setting ref');

  //     await storageFileRef.putFile(element);

  //     log('after putting file');

  //     final uploadTask = storageFileRef.putData(await element.readAsBytes());

  //     mediaUploadTasks.add(uploadTask);
  //     notifyListeners();

  //     for (var i in mediaUploadTasks) {
  //       tasksProgress += i.snapshot.bytesTransferred / i.snapshot.totalBytes;
  //       notifyListeners();
  //     }
  //     tasksProgress = tasksProgress / mediaUploadTasks.length;
  //     notifyListeners();

  //     final mediaRef = await uploadTask.whenComplete(() {});

  //     final fileUrl = await mediaRef.ref.getDownloadURL();
  //     voiceUrl = fileUrl;
  //     log('voice url $voiceUrl');
  //     notifyListeners();
  //   } on FirebaseException catch (e) {
  //     log("error 1  ${e.message}");

  //     GlobalSnackBar.show(message: e.toString());
  //   } on PlatformException catch (e) {
  //     log("error 2  ${e.message}");

  //     GlobalSnackBar.show(message: e.toString());
  //   }
  // }

  clearRecorder() {
    recordedFilePath = null;
    notifyListeners();
  }
}
