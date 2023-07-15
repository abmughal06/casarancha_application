// import 'dart:io';

// import 'package:casarancha/models/post_creator_details.dart';
// import 'package:casarancha/models/story_model.dart';
// import 'package:path/path.dart';

// import 'package:casarancha/models/media_details.dart';
// import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
// import 'package:casarancha/utils/snackbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class AddStoryController extends GetxController {
//   late ProfileScreenController profileScreenController;

//   final fbinstance = FirebaseFirestore.instance;

//   //Obserables

//   var mediaUploadTasks = Rxn<UploadTask>();
//   var mediaFile = Rxn<File>();

//   var mediaData = MediaDetails(id: '', name: '', type: '', link: '').obs;

//   var isSharingStory = false.obs;

//   //Methods

//   Future<void> shareStory() async {
//     if (mediaFile.value == null) {
//       GlobalSnackBar.show(message: 'Please add a Photo or Video');
//       return;
//     }
//     isSharingStory.value = true;
//     final creatorId = profileScreenController.user.value.id;

//     final storyRef = fbinstance.collection('stories').doc(creatorId);
//     final userRef = fbinstance.collection('users').doc(creatorId);
//     final storyId = storyRef.id;

//     final creatorDetails = CreatorDetails(
//       name: profileScreenController.user.value.name,
//       imageUrl: profileScreenController.user.value.imageStr,
//       isVerified: profileScreenController.user.value.isVerified,
//     );
//     try {
//       await uploadMediaFiles(storyId: storyId);

//       final storyData = await storyRef.get();

//       if (storyData.exists) {
//         await storyRef.update({
//           'mediaDetailsList': FieldValue.arrayUnion([
//             mediaData.value.toMap(),
//           ])
//         });
//       } else {
//         final story = Story(
//           id: storyId,
//           storyViews: [],
//           creatorId: creatorId,
//           creatorDetails: creatorDetails,
//           createdAt: DateTime.now().toIso8601String(),
//           mediaDetailsList: [mediaData.value],
//         );

//         await userRef.update({
//           'storiesIds': FieldValue.arrayUnion([storyId])
//         });

//         profileScreenController.user.update((val) {
//           val!.storiesIds.add(storyId);
//         });

//         await storyRef.set(story.toMap());
//       }

//       Get.back();
//     } catch (e) {
//       GlobalSnackBar(message: e.toString());
//     }
//     isSharingStory.value = false;
//   }

//   Future<void> uploadMediaFiles({required String storyId}) async {
//     final storageRef = FirebaseStorage.instance.ref();

//     try {
//       final String fileType = mediaData.value.type;
//       final String fileName = basename(mediaFile.value!.path);
//       final storageFileRef = storageRef.child('stories/$storyId/$fileName');
//       final uploadTask = storageFileRef.putFile(mediaFile.value!);
//       mediaUploadTasks.value = uploadTask;
//       final mediaRef = await uploadTask.whenComplete(() {});
//       final fileUrl = await mediaRef.ref.getDownloadURL();
//       final mediaDetails = MediaDetails(
//         id: DateTime.now().toIso8601String(),
//         name: fileName,
//         type: fileType,
//         link: fileUrl,
//       );
//       mediaData.value = mediaDetails;
//     } catch (e) {
//       GlobalSnackBar.show(message: e.toString());
//     }
//   }

//   Future<void> getMedia({required String type}) async {
//     try {
//       if (type == 'Photo') {
//         final pickedmedia = await ImagePicker().pickImage(
//           source: ImageSource.gallery,
//         );
//         mediaData.update((val) {
//           val!.type = type;
//         });

//         mediaFile.value = File(pickedmedia!.path);
//       } else {
//         final pickedmedia = await ImagePicker().pickVideo(
//           source: ImageSource.gallery,
//         );
//         mediaData.update((val) {
//           val!.type = type;
//         });
//         mediaFile.value = File(pickedmedia!.path);
//       }
//     } catch (e) {
//       GlobalSnackBar.show(message: 'Operation Cancelled');
//     }
//   }

//   void removeMedia() {
//     mediaFile.value = null;
//   }

//   //OverRides
//   @override
//   void onInit() {
//     profileScreenController = Get.find<ProfileScreenController>();
//     super.onInit();
//   }
// }
