import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:casarancha/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:open_file/open_file.dart';
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
    audioRecorder.hasPermission();
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
      var textMessage = messageController.text;
      messageController.clear();
      notifyListeners();
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
        lastMessage: textMessage,
        unreadMessageCount: 0,
        searchCharacters: [...appUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: appUser.name,
          imageUrl: appUser.imageStr,
          isVerified: appUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
      );

      final MessageDetails currentUserMessageDetails = MessageDetails(
        id: currentUser.id,
        lastMessage: textMessage,
        unreadMessageCount: unreadMessages + 1,
        searchCharacters: [...currentUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: currentUser.name,
          imageUrl: currentUser.imageStr,
          isVerified: currentUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
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
        content: textMessage,
        caption: '',
        type: 'Text',
        createdAt: DateTime.now().toUtc().toString(),
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
        createdAt: DateTime.now().toUtc().toString(),
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
        createdAt: DateTime.now().toUtc().toString(),
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
        createdAt: DateTime.now().toUtc().toString(),
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
    final ref = userRef
        .doc(appUserId)
        .collection('messageList')
        .doc(currentUserId)
        .collection("messages")
        .doc(messageid);
    final doc = await ref.get();
    if (doc.exists) {
      ref.update({
        'isSeen': true,
      });
    }
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
    final ref = userRef
        .doc(appUserId)
        .collection('ghostMessageList')
        .doc(currentUserId)
        .collection("messages")
        .doc(messageid);
    final doc = await ref.get();
    if (doc.exists) {
      ref.update({
        'isSeen': true,
      });
    }
  }

  void clearMessageController() {
    messageController.clear();
    unreadMessages = 0;
  }

  var photosList = <File>[];
  var videosList = <File>[];
  var musicList = <File>[];
  var mediaList = <File>[];
  var voiceList = <File>[];
  var mediaUploadTasks = <UploadTask>[];
  var mediaData = <MediaDetails>[];
  var allMediaFiles = <File>[];

  pickImageAndSentViaMessage(
      {UserModel? currentUser, UserModel? appUser, String? mediaType}) async {
    allMediaFiles = [
      ...photosList,
      ...videosList,
      ...musicList,
      ...mediaList,
      ...voiceList,
    ];

    photosList.clear();
    videosList.clear();
    musicList.clear();
    mediaList.clear();
    voiceList.clear();

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
        createdAt: DateTime.now().toUtc().toString(),
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
        createdAt: DateTime.now().toUtc().toString(),
      );

      final Message tempMessage = Message(
        id: messageRefForCurrentUser.id,
        sentToId: appUser.id,
        sentById: currentUser.id,
        content: 'upload',
        caption: 'uploading',
        type: '$mediaType',
        createdAt: DateTime.now().toUtc().toString(),
        isSeen: false,
      );

      await userRef
          .doc(currentUser.id)
          .collection('messageList')
          .doc(appUser.id)
          .set(
            appUserMessageDetails.toMap(),
          );
      messageRefForCurrentUser.set(tempMessage.toMap());

      await uploadMediaFiles(recieverId: currentUser.id, fileType: mediaType!);

      var message = tempMessage.copyWith(
        caption: '',
        content: mediaData.map((e) => e.toMap()).toList(),
      );

      await userRef
          .doc(appUser.id)
          .collection('messageList')
          .doc(currentUser.id)
          .set(
            currentUserMessageDetails.toMap(),
          );

      // log(message.toString());

      final appUserMessage = message.copyWith(id: messageRefForAppUser.id);

      messageRefForCurrentUser.update(message.toMap());
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

  pickImageAndSentViaMessageGhost(
      {UserModel? currentUser,
      UserModel? appUser,
      String? mediaType,
      bool? firstMessage}) async {
    allMediaFiles = [
      ...photosList,
      ...videosList,
      ...musicList,
      ...mediaList,
      ...voiceList,
    ];

    photosList.clear();
    videosList.clear();
    musicList.clear();
    mediaList.clear();
    voiceList.clear();
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
        lastMessage: mediaType == 'InChatVideo'
            ? "Video"
            : mediaType == 'InChatPic'
                ? "Photo"
                : mediaType == 'InChatDoc'
                    ? "Doc"
                    : 'Music',
        unreadMessageCount: 0,
        firstMessage: firstMessage! ? currentUser.id : appUser.id,
        searchCharacters: [...appUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: appUser.name,
          imageUrl: appUser.imageStr,
          isVerified: appUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
      );

      final GhostMessageDetails currentUserMessageDetails = GhostMessageDetails(
        id: currentUser.id,
        lastMessage: mediaType == 'InChatVideo'
            ? "Video"
            : mediaType == 'InChatPic'
                ? "Photo"
                : mediaType == 'InChatDoc'
                    ? "Doc"
                    : 'Music',
        unreadMessageCount: unreadMessages + 1,
        firstMessage: firstMessage ? currentUser.id : appUser.id,
        searchCharacters: [...currentUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: currentUser.name,
          imageUrl: currentUser.imageStr,
          isVerified: currentUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
      );

      // if (!isChatExits.value) {
      await userRef
          .doc(currentUser.id)
          .collection('ghostMessageList')
          .doc(appUser.id)
          .set(
            appUserMessageDetails.toMap(),
          );

      final Message tempMessage = Message(
        id: messageRefForCurrentUser.id,
        sentToId: appUser.id,
        sentById: currentUser.id,
        content: 'uploading',
        caption: 'uploading',
        type: '$mediaType',
        createdAt: DateTime.now().toUtc().toString(),
        isSeen: false,
      );
      messageRefForCurrentUser.set(tempMessage.toMap());

      await uploadMediaFiles(recieverId: currentUser.id, fileType: mediaType!);

      await userRef
          .doc(appUser.id)
          .collection('ghostMessageList')
          .doc(currentUser.id)
          .set(
            currentUserMessageDetails.toMap(),
          );

      // log(message.toString());

      final message = tempMessage.copyWith(
          caption: '', content: mediaData.map((e) => e.toMap()).toList());

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
    mediaList.clear();
    voiceList.clear();
    mediaUploadTasks.clear();
    allMediaFiles.clear();
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
    mediaList.clear();
    mediaUploadTasks.clear();
    mediaData.clear();
  }

  double tasksProgress = 0.0;

  bool isUploading = false;

  Future<void> uploadMediaFiles(
      {required String recieverId, required String fileType}) async {
    isUploading = false;
    notifyListeners();
    // final allMediaFiles = [
    //   ...photosList,
    //   ...videosList,
    //   ...musicList,
    //   ...mediaList,
    //   ...voiceList,
    // ];

    log(allMediaFiles.toString());

    final storageRef = FirebaseStorage.instance.ref();
    try {
      for (var element in allMediaFiles) {
        // final String fileType;
        final String fileName = basename(element.path);
        Size? imageSize;
        double? videoAspectRatio;

        // log('===> 1 $photosList');
        // log('===> 2 $voiceList');
        // log('===> 3 $videosList');
        // log('===> 4 $musicList');
        // log('===> 5 $mediaList');

        // if (photosList.contains(element)) {
        //   fileType = 'Photo';
        // } else if (videosList.contains(element)) {
        //   fileType = 'Video';
        // } else if (mediaList.contains(element)) {
        //   fileType = 'Media';
        // } else if (musicList.contains(element)) {
        //   fileType = 'Music';
        // } else {
        //   fileType = 'voice';
        // }

        if (fileType == 'InChatPic') {
          imageSize = await getImageSize(element);
        }
        if (fileType == 'InChatVideo') {
          videoAspectRatio = await getVideoAspectRatio(element);
        }

        final storageFileRef =
            storageRef.child('Chats/$recieverId/$fileType/$fileName');

        await storageFileRef.putData(await element.readAsBytes());

        final uploadTask = storageFileRef.putData(await element.readAsBytes());

        notifyListeners();

        // mediaUploadTasks.map(
        //   (e) => e.asStream().listen((event) {
        //     tasksProgress =
        //         e.snapshot.bytesTransferred / mediaUploadTasks.length;
        //     printLog('${(tasksProgress * 100).toStringAsFixed(1)}%');
        //     notifyListeners();
        //   }),
        // );

        // tasksProgress = tasksProgress / mediaUploadTasks.length;
        // printLog(tasksProgress.toString());
        notifyListeners();

        final mediaRef = await uploadTask.whenComplete(() {});

        final fileUrl = await mediaRef.ref.getDownloadURL();

        final MediaDetails mediaDetails;

        if (fileType == 'InChatPic') {
          mediaDetails = MediaDetails(
              id: DateTime.now().toUtc().toString(),
              name: fileName,
              type: fileType,
              link: fileUrl,
              imageHeight: imageSize?.height.toString(),
              imageWidth: imageSize?.width.toString());
        } else if (fileType == 'InChatVideo') {
          mediaDetails = MediaDetails(
            id: DateTime.now().toUtc().toString(),
            name: fileName,
            type: fileType,
            link: fileUrl,
            videoAspectRatio: videoAspectRatio.toString(),
          );
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
      isUploading = false;
      notifyListeners();
      log("error 1 === ${e.code} ${e.message}");

      GlobalSnackBar.show(message: e.message);
    } on PlatformException catch (e) {
      isUploading = false;
      notifyListeners();
      log("error 2  ${e.message}");

      GlobalSnackBar.show(message: e.message);
    } finally {
      isUploading = false;
      notifyListeners();
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

  bool isRecording = false;
  File? recordedFilePath;
  String? voiceUrl;
  Duration durationInSeconds = Duration.zero;
  late Timer timer;
  bool isRecordingSend = false;
  bool isRecorderLock = false;

  toggleRecorderLock() {
    isRecorderLock = true;
    notifyListeners();
  }

  startRecording() async {
    final String filename =
        '${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v4()}';

    log(filename);
    if (!await audioRecorder.hasPermission()) {
      return;
    }
    final dir = await getTemporaryDirectory();
    await audioRecorder.start(
      path: "${dir.path}/$filename.m4a",
    );
    isRecording = true;
    notifyListeners();

    startTimer();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      durationInSeconds = durationInSeconds + const Duration(seconds: 1);
      notifyListeners();
    });
  }

  cancelTimer() {
    timer.cancel();
    durationInSeconds = Duration.zero;
    log(timer.isActive.toString());
    log(durationInSeconds.toString());
    notifyListeners();
  }

  stopRecording({
    UserModel? currentUser,
    UserModel? appUser,
    bool? isGhostMessage,
    bool? firstMessageByWho,
  }) async {
    cancelTimer();

    try {
      String? path = await audioRecorder.stop();
      if (path == null) {
        // Handle the case where recording didn't produce a valid path
        return;
      }

      if (durationInSeconds.inMinutes < 60) {
        isRecording = false;
        recordedFilePath = File(path);

        voiceList.add(recordedFilePath!);

        log(voiceList.toString());

        if (voiceList.isEmpty) {
          return;
        }

        isGhostMessage!
            ? await sendVoiceMessageGhost(
                currentUser: currentUser,
                appUser: appUser,
                firstMessageByMe: firstMessageByWho,
              )
            : await sendVoiceMessage(
                currentUser: currentUser, appUser: appUser);
      } else {
        GlobalSnackBar.show(
            message: 'You cannot send a recording greater than 60 minutes');
        deleteRecording();
      }
      notifyListeners();
    } catch (e) {
      log('Error: $e');
    } finally {
      isRecorderLock = false;
      notifyListeners();
    }
  }

  sendVoiceMessage({UserModel? currentUser, UserModel? appUser}) async {
    isRecordingSend = true;
    notifyListeners();

    allMediaFiles = [...voiceList];

    try {
      log('done');

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
        lastMessage: 'voice message',
        unreadMessageCount: 0,
        searchCharacters: [...appUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: appUser.name,
          imageUrl: appUser.imageStr,
          isVerified: appUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
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
        createdAt: DateTime.now().toUtc().toString(),
      );

      final Message tempMessage = Message(
        id: messageRefForCurrentUser.id,
        sentToId: appUser.id,
        sentById: currentUser.id,
        content: 'voice uploading',
        caption: 'uploading',
        type: 'voice',
        createdAt: DateTime.now().toUtc().toString(),
        isSeen: false,
      );

      // if (!isChatExits.value) {
      await userRef
          .doc(currentUser.id)
          .collection('messageList')
          .doc(appUser.id)
          .set(
            appUserMessageDetails.toMap(),
          );
      await messageRefForCurrentUser.set(tempMessage.toMap());

      await uploadMediaFiles(recieverId: appUser.id, fileType: 'voice');

      var message = tempMessage.copyWith(
          caption: '', content: mediaData.map((e) => e.toMap()).toList());

      await userRef
          .doc(appUser.id)
          .collection('messageList')
          .doc(currentUser.id)
          .set(
            currentUserMessageDetails.toMap(),
          );

      final appUserMessage = message.copyWith(id: messageRefForAppUser.id);

      messageRefForCurrentUser.update(message.toMap());
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
    } finally {
      isRecordingSend = false;
      notifyListeners();
    }
  }

  sendVoiceMessageGhost(
      {UserModel? currentUser,
      UserModel? appUser,
      bool? firstMessageByMe}) async {
    isRecordingSend = true;
    notifyListeners();

    allMediaFiles = [...voiceList];

    try {
      log('done');

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
        lastMessage: 'voice message',
        firstMessage: firstMessageByMe! ? currentUser.id : appUser.id,
        unreadMessageCount: 0,
        searchCharacters: [...appUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: appUser.name,
          imageUrl: appUser.imageStr,
          isVerified: appUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
      );

      final GhostMessageDetails currentUserMessageDetails = GhostMessageDetails(
        id: currentUser.id,
        firstMessage: firstMessageByMe ? currentUser.id : appUser.id,
        lastMessage: 'voice message',
        unreadMessageCount: unreadMessages + 1,
        searchCharacters: [...currentUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: currentUser.name,
          imageUrl: currentUser.imageStr,
          isVerified: currentUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
      );

      // if (!isChatExits.value) {

      final Message tempMessage = Message(
        id: messageRefForCurrentUser.id,
        sentToId: appUser.id,
        sentById: currentUser.id,
        content: 'uploaddign',
        caption: 'uploading',
        type: 'voice',
        createdAt: DateTime.now().toUtc().toString(),
        isSeen: false,
      );
      await userRef
          .doc(currentUser.id)
          .collection('ghostMessageList')
          .doc(appUser.id)
          .set(
            appUserMessageDetails.toMap(),
          );
      messageRefForCurrentUser.set(tempMessage.toMap());

      await uploadMediaFiles(recieverId: appUser.id, fileType: 'voice');

      await userRef
          .doc(appUser.id)
          .collection('ghostMessageList')
          .doc(currentUser.id)
          .set(
            currentUserMessageDetails.toMap(),
          );

      // log(mediaData.toString());

      // log(message.toString());

      final message = tempMessage.copyWith(
          caption: '', content: mediaData.map((e) => e.toMap()).toList());

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
    } finally {
      isRecordingSend = false;
      notifyListeners();
    }
  }

  deleteRecording() async {
    try {
      await audioRecorder.stop();
      isRecording = false;
      clearRecorder();
      cancelTimer();
      isRecorderLock = false;
      notifyListeners();
    } catch (e) {
      log('Error: $e');
    } finally {}
  }

  clearRecorder() {
    recordedFilePath = null;
    notifyListeners();
  }

  deleteChat({friendId, docId}) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messageList')
          .doc(friendId)
          .collection('messages')
          .doc(docId)
          .delete();
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
      printLog(e.toString());
    } finally {}
  }
}
