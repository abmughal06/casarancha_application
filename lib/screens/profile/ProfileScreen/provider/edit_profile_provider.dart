import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/user_model.dart';
import '../../../../resources/localization_text_strings.dart';
import '../../../../utils/snackbar.dart';
import '../../../home/CreatePost/create_post_controller.dart';

class EditProfileProvider extends ChangeNotifier {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController userNameController;
  late TextEditingController bioController;

  String? profileImage, selectedDob;
  DateTime? getDateTime;
  List<bool> showSelectedDates = [true, true, true]; // day , month , year

  File? imageFilePicked;
  String bioTxtCount = "0";

  bool isLoading = false;

  EditProfileProvider() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    userNameController = TextEditingController();
    bioController = TextEditingController();
  }

  void clearAll() {
    firstNameController.clear();
    lastNameController.clear();
    userNameController.clear();
    bioController.clear();
    imageFilePicked = null;
  }

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
    notifyListeners();
  }

  bool checkValidData() {
    if (firstNameController.text.isEmpty) {
      GlobalSnackBar.show(message: 'Please enter $strFirstName');
      return false;
    } else if (lastNameController.text.isEmpty) {
      GlobalSnackBar.show(message: 'Please enter $strLastName');
      return false;
    } else if (userNameController.text.isEmpty) {
      GlobalSnackBar.show(message: "Please Enter $strUserName");
      return false;
    } else if (selectedDob == null || selectedDob == "") {
      GlobalSnackBar.show(message: 'Please enter $strDateOfBirth');
      return false;
    }
    //  else if (imageFilePicked == null && profileImage == null) {
    //   GlobalSnackBar.show(message: 'Please select image');
    //   return false;
    // }
    return true;
  }

  void updateData({UserModel? currentUser}) async {
    try {
      if (checkValidData()) {
        isLoading = true;
        notifyListeners();

        final userId = currentUser!.id;
        String imageUrl = currentUser.imageStr;
        String name = '${firstNameController.text} ${lastNameController.text}';

        if (imageFilePicked != null) {
          final ref = FirebaseStorage.instance.ref().child('profiles/$userId');
          final imageRef =
              await ref.putFile(imageFilePicked!).whenComplete(() {});

          imageUrl = await imageRef.ref.getDownloadURL();
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'name': name.trim(),
          'username': userNameController.text.trim(),
          'bio': bioController.text,
          'dob': selectedDob,
          'imageStr': imageUrl,
        });
      }
    } on FirebaseException catch (e) {
      GlobalSnackBar.show(message: e.message.toString());
    } catch (e) {
      GlobalSnackBar.show(message: "Something is wrong please try again.");
    } finally {
      isLoading = false;
      notifyListeners();
      Get.back();
    }
  }
}
