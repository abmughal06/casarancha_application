import 'dart:io';

import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_chat_screen.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';

import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';

import '../../utils/app_utils.dart';
import '../../utils/custom_date_picker.dart';
import '../../utils/snackbar.dart';
import '../../widgets/PostCard/postCard.dart';
import '../../widgets/PostCard/PostCardController.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/custome_firebase_list_view.dart';
import '../../widgets/text_editing_widget.dart';
import '../../widgets/text_widget.dart';
import '../home/CreatePost/create_post_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, required this.currentUser})
      : super(key: key);
  final UserModel currentUser;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _userNameController;
  late TextEditingController _bioController;
  ProfileScreenController profileScreenController =
      Get.find<ProfileScreenController>();

  String? _profileImage, _selectedDob;
  DateTime? _getDateTime;
  List<bool> showSelectedDates = [true, true, true]; // day , month , year

  File? imageFilePicked;
  String bioTxtCount = "0";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    var name = widget.currentUser.name.split(' ');

    _selectedDob = widget.currentUser.dob;
    _getDateTime = DateTime.parse(_selectedDob!);

    _profileImage = widget.currentUser.imageStr;

    _firstNameController = TextEditingController(text: name.first);
    _lastNameController = TextEditingController(text: name[1]);
    _userNameController =
        TextEditingController(text: widget.currentUser.username);
    _bioController = TextEditingController(text: widget.currentUser.bio);
    bioTxtCount = "${widget.currentUser.bio.length}";
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 400,
      maxHeight: 400,
    );
    if (pickedFile != null) {
      imageFilePicked = await cropImage(pickedFile.path);
      setState(() {});
    } else {
      GlobalSnackBar.show(message: 'Process Cancelled');
    }
  }

  bool _checkValidData() {
    if (_firstNameController.text.isEmpty) {
      GlobalSnackBar.show(
          context: context, message: 'Please enter $strFirstName');
      return false;
    } else if (_lastNameController.text.isEmpty) {
      GlobalSnackBar.show(
          context: context, message: 'Please enter $strLastName');
      return false;
    } else if (_userNameController.text.isEmpty) {
      GlobalSnackBar.show(
          context: context, message: "Please Enter $strUserName");
      return false;
    } else if (_bioController.text.isEmpty) {
      GlobalSnackBar.show(context: context, message: 'Please enter $strBio');
      return false;
    } else if (_selectedDob == null || _selectedDob == "") {
      GlobalSnackBar.show(
          context: context, message: 'Please enter $strDateOfBirth');
      return false;
    } else if (imageFilePicked == null && _profileImage == null) {
      GlobalSnackBar.show(context: context, message: 'Please select image');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(
        title: 'Setup Profile',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.w),
              children: [
                GestureDetector(
                  onTap: _getFromGallery,
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 127.h,
                      width: 127.w,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.passthrough,
                        children: [
                          imageFilePicked != null
                              ? Container(
                                  height: 150,
                                  width: 150,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: FileImage(imageFilePicked!))),
                                )
                              : _profileImage != null
                                  ? imgProVerified(
                                      imgRadius: 80,
                                      profileImg: _profileImage,
                                      idIsVerified: false)
                                  : CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          Image.asset(imgProfile).image,
                                    ),
                          Positioned(
                            bottom: 5.h,
                            left: 100.w,
                            child: SvgPicture.asset(
                              icProfileAdd,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                heightBox(20.w),
                TextEditingWidget(
                  controller: _firstNameController,
                  hintColor: color080,
                  isShadowEnable: false,
                  hint: strFirstName,
                  color: colorFF4,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                heightBox(10.w),
                TextEditingWidget(
                  controller: _lastNameController,
                  hintColor: color080,
                  isShadowEnable: false,
                  hint: strLastName,
                  color: colorFF4,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                heightBox(10.w),
                TextEditingWidget(
                  controller: _userNameController,
                  hintColor: color080,
                  isShadowEnable: false,
                  hint: strUserName,
                  maxLength: 10,
                  color: colorFF4,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                heightBox(10.w),
                SizedBox(
                  height: 156.h,
                  child: TextFormField(
                    controller: _bioController,
                    onChanged: (value) {
                      bioTxtCount = _bioController.text.length.toString();
                      setState(() {});
                    },
                    style: TextStyle(
                      color: color239,
                      fontSize: 16.sp,
                      fontFamily: strFontName,
                      fontWeight: FontWeight.w600,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(300),
                    ],
                    cursorColor: color239,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorFF4,
                      suffixIcon: Container(
                        padding: const EdgeInsets.all(10),
                        width: 75.w,
                        alignment: Alignment.bottomRight,
                        height: 150,
                        child: TextWidget(
                          text: "$bioTxtCount/300",
                          fontSize: 14.sp,
                          color: color080,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      hintText: strBio,
                      hintStyle: TextStyle(
                        color: const Color(0xFF3B3B3B).withOpacity(0.5),
                        fontSize: 16.sp,
                        fontFamily: strFontName,
                        fontWeight: FontWeight.w300,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none),
                    ),
                    maxLines: 5,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                  ),
                ),
                heightBox(10.w),
                CustomDatePicker(
                  getDateTime: _getDateTime!,
                  showSelected: showSelectedDates,
                  userDateTime: widget.currentUser.dob,
                  dateChangedCallback: (DateTime value) {
                    _getDateTime = value;
                    _selectedDob =
                        "${value.year}-${AppUtils.instance.convertSingleToTwoDigit(value.month.toString())}-${AppUtils.instance.convertSingleToTwoDigit(value.day.toString())}";
                    printLog(_selectedDob);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: CommonButton(
              height: 56.h,
              text: 'Continue',
              showLoading: isLoading,
              onTap: () async {
                try {
                  if (_checkValidData()) {
                    setState(() {
                      isLoading = true;
                    });

                    final userId = widget.currentUser.id;
                    String imageUrl = widget.currentUser.imageStr;
                    String name =
                        '${_firstNameController.text} ${_lastNameController.text}';

                    if (imageFilePicked != null) {
                      final ref = FirebaseStorage.instance
                          .ref()
                          .child('profiles/$userId');
                      final imageRef = await ref
                          .putFile(imageFilePicked!)
                          .whenComplete(() {});

                      imageUrl = await imageRef.ref.getDownloadURL();
                    }

                    final editedUser = widget.currentUser.copyWith(
                      name: name,
                      username: _userNameController.text,
                      bio: _bioController.text,
                      dob: _selectedDob,
                      imageStr: imageUrl,
                    );

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .update({
                      'name': name.trim(),
                      'username': _userNameController.text.trim(),
                      'bio': _bioController.text,
                      'dob': _selectedDob,
                      'imageStr': imageUrl,
                    });
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('ghostConversation')
                        .get()
                        .then((value) async {
                      for (var element in value.docs) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(element.data()['receiverId'])
                            .collection('ghostConversation')
                            .where("receiverId", isEqualTo: userId)
                            .get()
                            .then((value) async {
                          for (var e in value.docs) {
                            await e.reference.update({
                              'receiverName':
                                  _userNameController.text.toLowerCase().trim()
                            });
                          }
                        });
                      }
                    });
                    profileScreenController.user.value = editedUser;
                    Get.back();
                  }
                } on FirebaseException catch (e) {
                  GlobalSnackBar.show(
                      context: context, message: e.message.toString());
                } catch (e) {
                  GlobalSnackBar.show(
                      context: context,
                      message: "Something is wrong please try again.");
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              width: double.infinity,
            ),
          ),
          heightBox(10.w)
        ],
      ),
    );
  }
}
