import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:casarancha/utils/app_utils.dart';
import 'package:casarancha/widgets/text_widget.dart';
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

enum MessageType {
  text,
  inChatPic,
  photo,
  qoute,
  video,
  inChatVideo,
  storyPic,
  storyVideo,
  doc,
  music,
  inChatMusic,
  voice
}

String getConversationDocId(String userId1, String userId2) {
  List<String> sortedIds = [userId1, userId2]..sort();
  return sortedIds.join('_');
}

extension MyMessageTypeExtention on MessageType {
  String get name {
    switch (this) {
      case MessageType.text:
        return 'Text';
      case MessageType.inChatPic:
        return 'InChatPic';
      case MessageType.photo:
        return 'Photo';
      case MessageType.video:
        return 'Video';
      case MessageType.inChatVideo:
        return 'InChatVideo';
      case MessageType.music:
        return 'Music';
      case MessageType.inChatMusic:
        return 'InChatMusic';
      case MessageType.voice:
        return 'Voice';
      case MessageType.doc:
        return 'Doc';
      case MessageType.qoute:
        return 'Qoute';
      case MessageType.storyPic:
        return 'StoryPic';
      case MessageType.storyVideo:
        return 'StoryVideo';
    }
  }
}

class ChatProvider extends ChangeNotifier {
  late TextEditingController messageController;
  late Record audioRecorder;

  String? conversationId;

  ChatProvider() {
    messageController = TextEditingController();
    audioRecorder = Record();
    audioRecorder.hasPermission();
  }

  final textFieldFocus = FocusNode();

  String? appUserName;

  setUserName(id) async {
    var ref = FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) => value['name']);
    appUserName = await ref;
  }

  bool isExpanded = false;
  bool isReply = false;
  Message? replyingMessage;

  var isChatExits = false;
  var isChecking = false;

  var photosList = <File>[];
  var videosList = <File>[];
  var musicList = <File>[];
  var mediaList = <File>[];
  var voiceList = <File>[];
  var mediaUploadTasks = <UploadTask>[];
  var mediaData = <MediaDetails>[];
  var allMediaFiles = <File>[];

  int unreadMessages = 0;

  final userRef = FirebaseFirestore.instance.collection("users");

  MessageType checkMessageType() {
    if (photosList.isNotEmpty) {
      return MessageType.inChatPic;
    } else if (videosList.isNotEmpty) {
      return MessageType.inChatVideo;
    } else if (musicList.isNotEmpty) {
      return MessageType.inChatMusic;
    } else if (voiceList.isNotEmpty) {
      return MessageType.voice;
    } else if (mediaList.isNotEmpty) {
      return MessageType.doc;
    } else {
      return MessageType.text;
    }
  }

  String getMediaType(String name) {
    switch (name) {
      case 'InChatPic':
        return 'Photo';
      case 'InChatVideo':
        return 'Video';
      case 'InChatMusic':
        return 'Music';
      case 'Voice':
        return 'Voice';
      case 'Photo' || 'Video' || 'Quote' || 'Music':
        return 'Post';
      case 'Text':
        return 'Text';
      case 'Doc':
        return 'Doc';
      case 'story-Video' || 'story-Photo':
        return 'Story';
      default:
        return '';
    }
  }

  Future<void> sentTextMessage({
    UserModel? currentUser,
    UserModel? appUser,
  }) async {
    if (messageController.text.isEmpty) {
      return;
    }
    try {
      var textMessage = messageController.text;
      messageController.clear();
      notifyListeners();
      var docId = getConversationDocId(currentUser!.id, appUser!.id);

      conversationId = docId;

      final messageRef =
          FirebaseFirestore.instance.collection('messages').doc(conversationId);

      final chatRef = messageRef.collection('chats').doc();

      final lastMessageDetails = MessageDetails(
        id: messageRef.id,
        creatorId: currentUser.id,
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

      final Message message = Message(
        id: chatRef.id,
        sentToId: appUser.id,
        sentById: currentUser.id,
        isReply: false,
        content: textMessage,
        caption: '',
        type: MessageType.text.name,
        createdAt: DateTime.now().toUtc().toString(),
        isSeen: false,
      );

      messageRef.set(lastMessageDetails.toMap());

      chatRef.set(message.toMap());

      FirebaseMessagingService().sendNotificationToUser(
        appUserId: appUser.id,
        notificationType: "msg",
        devRegToken: appUser.fcmToken,
        msg: textMessage,
        ghostmode: false,
        isMessage: true,
      );
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    } finally {}
  }

  enableReply(Message message) {
    isReply = true;
    replyingMessage = message;
    textFieldFocus.requestFocus();
    notifyListeners();
  }

  disableReply() {
    isReply = false;
    replyingMessage = null;
    // textFieldFocus.unfocus();
    notifyListeners();
  }

  Future<void> replyMessage({
    // required MessageDetails messageDetails,
    required UserModel appUser,
    required UserModel currentUser,
  }) async {
    try {
      if (isReply && replyingMessage != null) {
        var textMessage = messageController.text;
        messageController.clear();
        notifyListeners();

        final messageRef = FirebaseFirestore.instance
            .collection('messages')
            .doc(getConversationDocId(currentUser.id, appUser.id));

        final chatRef = messageRef.collection('chats').doc();

        final newMessageDetails = MessageDetails(
          id: getConversationDocId(currentUser.id, appUser.id),
          creatorId: currentUser.id,
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

        final newMessage = Message(
          sentById: FirebaseAuth.instance.currentUser!.uid,
          sentToId: appUser.id,
          isSeen: false,
          type: checkMessageType().name,
          id: chatRef.id,
          content: textMessage,
          caption: replyingMessage!.type == 'Text'
              ? replyingMessage!.content
              : getMediaType(replyingMessage!.type),
          isReply: isReply,
          createdAt: DateTime.now().toUtc().toString(),
        );

        messageRef.set(newMessageDetails.toMap());

        chatRef.set(newMessage.toMap());

        FirebaseMessagingService().sendNotificationToUser(
          appUserId: appUser.id,
          notificationType: "msg",
          ghostmode: false,
          devRegToken: appUser.fcmToken,
          msg: textMessage,
          isMessage: true,
        );
      }
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    } finally {
      disableReply();
    }
  }

  Future<void> replyMessageGhost(
      {required UserModel appUser,
      required UserModel currentUser,
      bool? firstMessageByMe}) async {
    try {
      if (isReply && replyingMessage != null) {
        var textMessage = messageController.text;
        messageController.clear();
        notifyListeners();

        final messageRef = FirebaseFirestore.instance
            .collection('ghost_messages')
            .doc(getConversationDocId(currentUser.id, appUser.id));

        final chatRef = messageRef.collection('chats').doc();

        final newMessageDetails = GhostMessageDetails(
          id: getConversationDocId(currentUser.id, appUser.id),
          lastMessage: textMessage,
          unreadMessageCount: unreadMessages + 1,
          searchCharacters: [...currentUser.name.toLowerCase().split('')],
          creatorDetails: CreatorDetails(
            name: currentUser.name,
            imageUrl: currentUser.imageStr,
            isVerified: currentUser.isVerified,
          ),
          createdAt: DateTime.now().toUtc().toString(),
          firstMessage: firstMessageByMe! ? currentUser.id : appUser.id,
        );

        final newMessage = Message(
          sentById: FirebaseAuth.instance.currentUser!.uid,
          sentToId: appUser.id,
          isSeen: false,
          type: checkMessageType().name,
          id: chatRef.id,
          content: textMessage,
          caption: replyingMessage!.type == 'Text'
              ? replyingMessage!.content
              : getMediaType(replyingMessage!.type),
          isReply: isReply,
          createdAt: DateTime.now().toUtc().toString(),
        );

        messageRef.set(newMessageDetails.toMap());

        chatRef.set(newMessage.toMap());

        FirebaseMessagingService().sendNotificationToUser(
          appUserId: appUser.id,
          notificationType: "msg",
          ghostmode: false,
          devRegToken: appUser.fcmToken,
          msg: textMessage,
          isMessage: true,
        );
      }
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    } finally {
      disableReply();
    }
  }

  Future<void> sentMessageGhost({
    UserModel? currentUser,
    UserModel? appUser,
    bool? firstMessageByMe,
    String? notificationText,
  }) async {
    if (messageController.text.isEmpty) {
      return;
    }
    try {
      var textMessage = messageController.text;
      messageController.clear();
      notifyListeners();
      var docId =
          conversationId ?? getConversationDocId(currentUser!.id, appUser!.id);

      conversationId = docId;

      final messageRef = FirebaseFirestore.instance
          .collection('ghost_messages')
          .doc(conversationId);

      final chatRef = messageRef.collection('chats').doc();

      final GhostMessageDetails lastMessageDetails = GhostMessageDetails(
        id: messageRef.id,
        lastMessage: textMessage.trim(),
        firstMessage: firstMessageByMe! ? currentUser!.id : appUser!.id,
        unreadMessageCount: unreadMessages + 1,
        searchCharacters: [...currentUser!.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: currentUser.name,
          imageUrl: currentUser.imageStr,
          isVerified: currentUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
      );

      final Message message = Message(
        id: chatRef.id,
        sentToId: appUser!.id,
        isReply: false,
        sentById: currentUser.id,
        content: textMessage.trim(),
        caption: '',
        type: 'Text',
        createdAt: DateTime.now().toUtc().toString(),
        isSeen: false,
      );

      messageRef.set(lastMessageDetails.toMap());
      chatRef.set(message.toMap());

      FirebaseMessagingService().sendNotificationToUser(
        appUserId: appUser.id,
        devRegToken: appUser.fcmToken,
        isMessage: true,
        notificationType: "msg",
        ghostmode: true,
        msg: messageController.text,
      );

      messageController.clear();
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }
  }

  Future<void> resetMessageCount({
    messageid,
  }) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc("$conversationId")
        .update({
      'unreadMessageCount': 0,
    });

    final ref = FirebaseFirestore.instance
        .collection('messages')
        .doc("$conversationId")
        .collection("chats")
        .doc(messageid);
    final doc = await ref.get();
    if (doc.exists) {
      ref.update({
        'isSeen': true,
      });
    }
  }

  Future<void> resetMessageCountGhost({
    messageid,
  }) async {
    await FirebaseFirestore.instance
        .collection('ghost_messages')
        .doc("$conversationId")
        .update({
      'unreadMessageCount': 0,
    });

    final ref = FirebaseFirestore.instance
        .collection('ghost_messages')
        .doc("$conversationId")
        .collection("chats")
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

  sendMediaMessage({
    UserModel? currentUser,
    UserModel? appUser,
    String? notificationText,
  }) async {
    allMediaFiles = [
      ...photosList,
      ...videosList,
      ...musicList,
      ...mediaList,
      ...voiceList,
    ];

    var mediaType = checkMessageType().name;

    photosList.clear();
    videosList.clear();
    musicList.clear();
    mediaList.clear();
    voiceList.clear();

    try {
      final docId = getConversationDocId(currentUser!.id, appUser!.id);
      conversationId = docId;
      final messageRef =
          FirebaseFirestore.instance.collection('messages').doc(conversationId);

      final chatRef = messageRef.collection('chats').doc();

      final MessageDetails messageDetails = MessageDetails(
        id: messageRef.id,
        creatorId: currentUser.id,
        lastMessage: mediaType,
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
        id: chatRef.id,
        sentToId: appUser.id,
        sentById: currentUser.id,
        isReply: false,
        content: 'upload',
        caption: messageController.text,
        type: mediaType,
        createdAt: DateTime.now().toUtc().toString(),
        isSeen: false,
      );
      messageController.clear();
      notifyListeners();

      chatRef.set(tempMessage.toMap());

      await uploadMediaFiles(recieverId: currentUser.id, fileType: mediaType)
          .whenComplete(() => null);

      var message = tempMessage.copyWith(
        content: mediaData.map((e) => e.toMap()).toList(),
      );
      messageRef.set(messageDetails.toMap());
      chatRef.update(message.toMap());
      clearLists();

      unreadMessages += 1;
      notifyListeners();

      await FirebaseMessagingService().sendNotificationToUser(
        notificationType: "msg",
        appUserId: appUser.id,
        devRegToken: appUser.fcmToken,
        msg: notificationText,
        ghostmode: false,
        isMessage: true,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  sendMediaMessageGhost({
    UserModel? currentUser,
    UserModel? appUser,
    bool? firstMessage,
    String? notificationText,
  }) async {
    allMediaFiles = [
      ...photosList,
      ...videosList,
      ...musicList,
      ...mediaList,
      ...voiceList,
    ];

    var mediaType = checkMessageType().name;

    photosList.clear();
    videosList.clear();
    musicList.clear();
    mediaList.clear();
    voiceList.clear();
    try {
      conversationId =
          conversationId ?? getConversationDocId(currentUser!.id, appUser!.id);
      final messageRef = FirebaseFirestore.instance
          .collection('ghost_messages')
          .doc(conversationId);

      final GhostMessageDetails messageDetails = GhostMessageDetails(
        id: messageRef.id,
        lastMessage: mediaType,
        unreadMessageCount: 0,
        firstMessage: firstMessage! ? currentUser!.id : appUser!.id,
        searchCharacters: [...appUser!.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: appUser.name,
          imageUrl: appUser.imageStr,
          isVerified: appUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
      );

      final chatRef = messageRef.collection('chats').doc();

      final Message tempMessage = Message(
        id: chatRef.id,
        sentToId: appUser.id,
        isReply: false,
        sentById: currentUser!.id,
        content: 'uploading',
        caption: 'uploading',
        type: mediaType,
        createdAt: DateTime.now().toUtc().toString(),
        isSeen: false,
      );
      await chatRef.set(tempMessage.toMap());

      await uploadMediaFiles(recieverId: currentUser.id, fileType: mediaType);

      var message = tempMessage.copyWith(
        caption: '',
        content: mediaData.map((e) => e.toMap()).toList(),
      );
      messageRef.set(messageDetails.toMap());
      chatRef.update(message.toMap());

      clearLists();

      FirebaseMessagingService().sendNotificationToUser(
          appUserId: appUser.id,
          isMessage: true,
          devRegToken: appUser.fcmToken,
          notificationType: "msg",
          msg: notificationText,
          ghostmode: true);
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

    final storageRef = FirebaseStorage.instance.ref();
    try {
      for (var element in allMediaFiles) {
        final String fileName = basename(element.path);
        Size? imageSize;

        if (fileType == 'InChatPic') {
          imageSize = await getImageSize(element);
        }

        final storageFileRef =
            storageRef.child('Chats/$recieverId/$fileType/$fileName');

        await storageFileRef.putData(await element.readAsBytes());

        final uploadTask = storageFileRef.putData(await element.readAsBytes());

        notifyListeners();

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
            videoAspectRatio: '0.58',
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

  Future<void> getPhoto(context) async {
    try {
      final pickedPhoto = await ImagePicker().pickMultiImage();

      if (pickedPhoto.isNotEmpty) {
        for (var i in pickedPhoto) {
          var image = File(i.path);
          photosList.add(image);
        }

        printLog(allMediaFiles.toString());
        notifyListeners();
      }
    } catch (e) {
      GlobalSnackBar.show(message: appText(context).gsbOperationCancelled);
    }
  }

  Future<void> takeCameraPic(context) async {
    try {
      final pickedPhoto =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedPhoto != null) {
        var image = File(pickedPhoto.path);
        photosList.add(image);
        notifyListeners();
      }
    } catch (e) {
      GlobalSnackBar.show(message: appText(context).gsbOperationCancelled);
    }
  }

  void removePhotoFile(File photoFile) {
    photosList.remove(photoFile);
    notifyListeners();
  }

  Future<void> getVideo(context) async {
    final File videoFileHelper;
    try {
      final pickedVideo = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );
      videoFileHelper = File(pickedVideo!.path);
      videosList.add(videoFileHelper);
      // log(videosList.toString());
    } catch (e) {
      GlobalSnackBar.show(message: appText(context).gsbOperationCancelled);
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
      GlobalSnackBar.show(message: appText(context).gsbOperationCancelled);
    }
    notifyListeners();
  }

  void removeMusicFile(File musicFile) {
    musicList.remove(musicFile);
    notifyListeners();
  }

  Future<void> getMedia(context) async {
    final List<File> mediaFilesHelper = [];
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      for (var element in result!.files) {
        log('========>>>>>');
        mediaFilesHelper.add(File(element.path ?? ''));
      }

      mediaList.assignAll(mediaFilesHelper);
      log(mediaList.toString());
    } catch (e) {
      GlobalSnackBar.show(message: appText(context).gsbOperationCancelled);
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

    if (!await audioRecorder.hasPermission()) {
      return;
    }
    isRecording = true;
    notifyListeners();
    final dir = await getTemporaryDirectory();
    Timer(const Duration(milliseconds: 500), () async {
      await audioRecorder.start(
        path: "${dir.path}/$filename.m4a",
      );

      startTimer();
    });
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
    notifyListeners();
  }

  stopRecording({
    UserModel? currentUser,
    UserModel? appUser,
    bool? isGhostMessage,
    bool? firstMessageByWho,
    String? notificationText,
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

        if (voiceList.isEmpty) {
          return;
        }

        isGhostMessage!
            ? await sendMediaMessageGhost(
                currentUser: currentUser,
                appUser: appUser,
                firstMessage: firstMessageByWho,
              )
            : await sendMediaMessage(
                currentUser: currentUser,
                appUser: appUser,
                notificationText: notificationText,
              );
      } else {
        GlobalSnackBar.show(message: appText(context).strRecordingRestriction);
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

  deleteChat({messageId}) async {
    try {
      final messageRef =
          FirebaseFirestore.instance.collection('messages').doc(conversationId);
      final chatRef = messageRef.collection('chats').doc(messageId);

      await messageRef.collection('chats').get().then((messages) async {
        if (messages.docs.length > 1) {
          chatRef.delete();
          MessageDetails lastMessage;
          await messageRef.get().then((value) {
            lastMessage = MessageDetails.fromMap(value.data());
            final newMessage =
                lastMessage.copyWith(lastMessage: 'Last message deleted');
            messageRef.update(newMessage.toMap());
          });
        } else {
          chatRef.delete();
          messageRef.delete();
        }
      });
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
      printLog(e.toString());
    } finally {}
  }

  unsendMessage({messageId}) async {
    try {
      final messageRef =
          FirebaseFirestore.instance.collection('messages').doc(conversationId);
      final chatRef = messageRef.collection('chats').doc(messageId);
      chatRef.delete();
      messageRef.delete();
      // await messageRef.collection('chats').get().then((messages) async {
      //   if (messages.docs.length > 1) {
      //     chatRef.delete();
      //     MessageDetails lastMessage;
      //     await messageRef.get().then((value) {
      //       lastMessage = MessageDetails.fromMap(value.data());
      //       final newMessage =
      //           lastMessage.copyWith(lastMessage: 'Last message deleted');
      //       messageRef.update(newMessage.toMap());
      //     });
      //   } else {

      //   }
      // });
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
      printLog(e.toString());
    } finally {}
  }

  bool isMessageEditing = false;
  String? editMessageId;

  enableEditing(messageId, isGhost) async {
    isMessageEditing = true;
    final messageRef = FirebaseFirestore.instance
        .collection(isGhost ? 'ghost_messages' : 'messages')
        .doc(conversationId);
    final chatRef = messageRef.collection('chats').doc(messageId);
    editMessageId = messageId;
    Message lastMessage;
    await chatRef.get().then((value) {
      lastMessage = Message.fromMap(value.data()!);
      messageController.text = lastMessage.content;
      editMessageId = messageId;
      textFieldFocus.requestFocus();
      // final newMessage =
      //     lastMessage.copyWith(content: messageController.text.trim());
      // chatRef.update(newMessage.toMap());
    });
    notifyListeners();
  }

  editMessage(isGhost, messageId) async {
    try {
      final messageRef = FirebaseFirestore.instance
          .collection(isGhost ? 'ghost_messages' : 'messages')
          .doc(conversationId);
      final chatRef = messageRef.collection('chats').doc(messageId);

      Message lastMessage;
      await chatRef.get().then((value) {
        lastMessage = Message.fromMap(value.data()!);
        final newMessage =
            lastMessage.copyWith(content: messageController.text.trim());
        chatRef.update(newMessage.toMap());
      });
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
      printLog(e.toString());
    } finally {
      isMessageEditing = false;
      editMessageId = null;
      messageController.clear();
      notifyListeners();
    }
  }
}
