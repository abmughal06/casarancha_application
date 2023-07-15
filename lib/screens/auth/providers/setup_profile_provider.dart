import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../models/user_model.dart';
import '../../../resources/firebase_cloud_messaging.dart';
import '../../../resources/localization_text_strings.dart';
import '../../../utils/snackbar.dart';
import '../../../view_models/profile_vm/edit_profie_view_model.dart';
import '../../dashboard/dashboard.dart';
import 'package:http/http.dart' as http;

class SetupProfileProvider extends ChangeNotifier {
  String? profileImage, selectedDob;
  DateTime? getDateTime;
  List<bool> showSelectedDates = [false, false, false]; // day , month , year
  EditProfileScViewModel? editProfileScViewModel;

  File? imageFilePicked;
  String bioTxtCount = "0";

  bool isLoading = false;

  getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 400,
      maxHeight: 400,
    );
    if (pickedFile != null) {
      imageFilePicked = await cropImage(pickedFile.path);
      notifyListeners();
    } else {
      GlobalSnackBar.show(message: 'Process Cancelled');
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

  bool checkValidData({String? fname, String? lname, String? username}) {
    if (fname!.isEmpty) {
      GlobalSnackBar.show(message: 'Please enter $strFirstName');

      return false;
    } else if (lname!.isEmpty) {
      GlobalSnackBar.show(message: 'Please enter $strLastName');

      return false;
    } else if (username!.isEmpty) {
      GlobalSnackBar.show(message: "Please Enter $strUserName");

      return false;
    } else if (selectedDob == null || selectedDob == "") {
      GlobalSnackBar.show(message: 'Please enter $strDateOfBirth');

      return false;
    } else if (imageFilePicked == null && profileImage == null) {
      GlobalSnackBar.show(message: 'Please select image');

      return false;
    }

    return true;
  }

  FirebaseMessagingService message = FirebaseMessagingService();

  setupProfileData(
      {String? fname, String? lname, String? username, String? bio}) async {
    try {
      if (checkValidData(fname: fname, lname: lname, username: username)) {
        isLoading = true;
        notifyListeners();

        final userDate = FirebaseAuth.instance.currentUser;
        final userId = userDate!.uid;
        final userEmail = userDate.email ?? '';

        final ref = FirebaseStorage.instance.ref().child('profiles/$userId');
        TaskSnapshot? imageRef;
        if (imageFilePicked == null) {
          if (profileImage != null) {
            final response = await http.get(Uri.parse(profileImage!));

            final documentDirectory = await getApplicationDocumentsDirectory();

            final file = File("${documentDirectory.path}imagetest.png");

            file.writeAsBytesSync(response.bodyBytes);

            imageRef = await ref.putFile(file).whenComplete(() {});
          }
        } else {
          imageRef = await ref.putFile(imageFilePicked!).whenComplete(() {});
        }

        final imageUrl = await imageRef?.ref.getDownloadURL();
        var token = await message.getFirebaseToken();

        final userModel = UserModel(
          id: userId,
          email: userEmail,
          ghostName: "Ghost---- ${Random().nextInt(6)}",
          username: username!,
          dob: selectedDob.toString(),
          fcmToken: token,
          name: '${fname!.trim()} ${lname!.trim()} ',
          createdAt: DateTime.now().toIso8601String(),
          bio: bio!.trim(),
          imageStr: imageUrl ?? "",
          isOnline: false,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set(userModel.toMap());

        Get.offAll(() => const DashBoard());
      }
    } on FirebaseException catch (e) {
      GlobalSnackBar.show(message: e.message.toString());
    } catch (e) {
      GlobalSnackBar.show(message: "Something is wrong please try again.");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
