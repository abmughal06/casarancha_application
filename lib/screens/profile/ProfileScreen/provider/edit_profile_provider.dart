import 'dart:io';

import 'package:casarancha/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/user_model.dart';
import '../../../../utils/snackbar.dart';

class EditProfileProvider extends ChangeNotifier {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController userNameController;
  late TextEditingController bioController;
  late TextEditingController workController;
  late TextEditingController educationController;

  String? profileImage, selectedDob;
  DateTime? getDateTime;
  List<bool> showSelectedDates = [true, true, true]; // day , month , year

  File? imageFilePicked;
  String bioTxtCount = "0";
  String educationTxtCount = "0";
  String workTxtCount = "0";

  bool isLoading = false;

  EditProfileProvider() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    userNameController = TextEditingController();
    bioController = TextEditingController();
    educationController = TextEditingController();
    workController = TextEditingController();
  }

  void clearAll() {
    firstNameController.clear();
    lastNameController.clear();
    userNameController.clear();
    bioController.clear();
    workController.clear();
    educationController.clear();
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
      imageFilePicked = File(pickedFile.path);
      notifyListeners();
    } else {
      // GlobalSnackBar.show(message: appText(context).strProcessCancelled);
    }
    notifyListeners();
  }

  bool checkValidData(context) {
    if (firstNameController.text.isEmpty) {
      GlobalSnackBar.show(message: appText(context).strEnterFirstName);
      return false;
    } else if (lastNameController.text.isEmpty) {
      GlobalSnackBar.show(message: appText(context).strEnterLastName);
      return false;
    } else if (userNameController.text.isEmpty) {
      GlobalSnackBar.show(message: appText(context).strEnterUserName);
      return false;
    } else if (selectedDob == null || selectedDob == "") {
      GlobalSnackBar.show(message: appText(context).strEnterDOB);
      return false;
    }
    //  else if (imageFilePicked == null && profileImage == null) {
    //   GlobalSnackBar.show(message: 'Please select image');
    //   return false;
    // }
    return true;
  }

  Future<void> updateData(context, {UserModel? currentUser}) async {
    try {
      if (checkValidData(context)) {
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
          'work': workController.text,
          'education': educationController.text,
          'imageStr': imageUrl,
        });

        GlobalSnackBar.show(message: 'Profile updated sucessfully');
      }
    } on FirebaseException catch (e) {
      GlobalSnackBar.show(message: e.message.toString());
    } catch (e) {
      GlobalSnackBar.show(message: appText(context).strSomethingWrong);
    } finally {
      isLoading = false;
      notifyListeners();
      // Get.back();
    }
  }
}
