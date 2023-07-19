// import 'dart:io';

// import 'package:casarancha/models/media_details.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../models/post_creator_details.dart';
// import '../../../models/post_model.dart';
// import '../../../models/user_model.dart';
// import '../../../utils/snackbar.dart';

// class CreatePostMethods extends ChangeNotifier {
//   FirebaseFirestore fbinstance = FirebaseFirestore.instance;
//   FirebaseAuth fauth = FirebaseAuth.instance;

//   late UserModel user;

//   CreatePostMethods({required this.user});

//   List<MediaDetails> mediaData = [];
//   List<File> photosList = [];
//   List<File> videosList = [];
//   List<File> musicList = [];
//   List<String> qouteList = [];
//   String? _qouteText;

//   Future<void> sharePost(
//       {String? groupId,
//       bool showPostTime = true,
//       String? desc,
//       String? location}) async {
//     final postRef = groupId != null
//         ? fbinstance.collection('groups').doc(groupId).collection('posts').doc()
//         : fbinstance.collection('posts').doc();
//     final userRef = fbinstance.collection('users').doc(user.id);
//     await postRef.set({});
//     final postId = postRef.id;
//     final creatorId = user.id;
//     final creatorDetails = CreatorDetails(
//       name: user.username,
//       imageUrl: user.imageStr,
//       isVerified: user.isVerified,
//     );
//     try {
//       await uploadMediaFiles(postId: postId);
//       final post = PostModel(
//         id: postId,
//         creatorId: creatorId,
//         creatorDetails: creatorDetails,
//         createdAt: DateTime.now().toIso8601String(),
//         description: desc!,
//         locationName: location!,
//         shareLink: '',
//         showPostTime: showPostTime,
//         mediaData: mediaData,
//       );

//       DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();
//       UserModel userModel = UserModel.fromMap(userSnapshot.data() ?? {});
//       await userRef.update({
//         "postsIds": FieldValue.arrayUnion([userModel.postsIds])
//       });

//       await postRef.set(post.toMap());
//       Get.back();
//       Get.back();
//     } catch (e) {
//       GlobalSnackBar(message: e.toString());
//     }
//   }

//   Future<void> uploadMediaFiles({required String postId}) async {
//     final qouteText = _qouteText;

//     if (qouteText!.isNotEmpty) {
//       mediaData.add(
//         MediaDetails(
//           id: DateTime.now().toUtc().toIso8601String(),
//           name: 'Nothing',
//           type: 'Qoute',
//           link: qouteText,
//         ),
//       );
//     }

//     final allMediaFiles = [...photosList, ...videosList, ...musicList];

//     final storageRef = FirebaseStorage.instance.ref();

//     try {
//       for (var element in allMediaFiles) {
//         final String fileType;
//         final String fileName = basename(element.path);
//         Size? imageSize;
//         double? videoAspectRatio;

//         if (photosList.contains(element)) {
//           fileType = 'Photo';
//           imageSize = await getImageSize(element);
//         } else if (videosList.contains(element)) {
//           fileType = 'Video';
//           videoAspectRatio = await getVideoAspectRatio(element);
//         } else {
//           fileType = 'Music';
//         }
// /* 
// File image = new File('image.png'); // Or any other way to get a File instance.
// var decodedImage = await decodeImageFromList(image.readAsBytesSync());
// print(decodedImage.width);
// print(decodedImage.height);
//  */
//         final storageFileRef = storageRef.child('Posts/$postId/$fileName');

//         final uploadTask = storageFileRef.putFile(element);
//         mediaUploadTasks.add(uploadTask);
//         final mediaRef = await uploadTask.whenComplete(() {});
//         final fileUrl = await mediaRef.ref.getDownloadURL();
//         final MediaDetails mediaDetails;
//         if (fileType == 'Photo') {
//           mediaDetails = MediaDetails(
//               id: DateTime.now().toUtc().toIso8601String(),
//               name: fileName,
//               type: fileType,
//               link: fileUrl,
//               imageHeight: imageSize?.height.toString(),
//               imageWidth: imageSize?.width.toString());
//         } else if (fileType == 'Video') {
//           mediaDetails = MediaDetails(
//               id: DateTime.now().toUtc().toIso8601String(),
//               name: fileName,
//               type: fileType,
//               link: fileUrl,
//               videoAspectRatio: videoAspectRatio?.toString());
//         } else {
//           mediaDetails = MediaDetails(
//             id: DateTime.now().toUtc().toIso8601String(),
//             name: fileName,
//             type: fileType,
//             link: fileUrl,
//           );
//         }
//         mediaData.add(mediaDetails);
//       }
//     } catch (e) {
//       GlobalSnackBar.show(message: e.toString());
//     }
//   }
// }
