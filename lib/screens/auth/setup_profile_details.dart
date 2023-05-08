// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_controller.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/firebase_cloud_messaging.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_utils.dart';
import '../../utils/custom_date_picker.dart';
import '../../utils/snackbar.dart';
import '../../view_models/profile_vm/edit_profie_view_model.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';
import '../../widgets/text_widget.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({Key? key}) : super(key: key);

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String? _profileImage, _selectedDob;
  DateTime? _getDateTime;
  List<bool> showSelectedDates = [false, false, false]; // day , month , year
  EditProfileScViewModel? editProfileScViewModel;

  File? imageFilePicked;
  String bioTxtCount = "0";

  bool isLoading = false;

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

  FirebaseMessagingService message = FirebaseMessagingService();

  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user?.displayName != null) {
      _userNameController.text = user!.displayName!;
      List<String> name = user.displayName!.split(" ");

      if (name.isNotEmpty && name.length < 2) {
        _firstNameController.text = name[0];
      } else if (name.isNotEmpty && name.length < 3) {
        _firstNameController.text = name[0];
        _lastNameController.text = name[1];
      }
    }
    if (user?.photoURL != null) {
      _profileImage = user?.photoURL;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(
          title: 'Setup Profile',
          showBackButton: false,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Get.offAll(() => const LoginScreen());
                },
                icon: Icon(Icons.logout_rounded))
          ]),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.w),
              children: [
                GestureDetector(
                  onTap: _getFromGallery,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.passthrough,
                    children: [
                      imageFilePicked != null
                          ? Container(
                              height: 120,
                              width: 120,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(imageFilePicked!))),
                            ) /* CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  Image.file(imageFilePicked!).image) */
                          : _profileImage != null
                              ? imgProVerified(
                                  profileImg: _profileImage,
                                  idIsVerified: false)
                              : Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: colorPrimaryA05, width: 1.5),
                                      image: const DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image:
                                              AssetImage(imgUserPlaceHolder))),
                                ),
                      Positioned(
                        bottom: 5.h,
                        right: 100.w,
                        child: SvgPicture.asset(
                          icProfileAdd,
                        ),
                      ),
                    ],
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
                  getDateTime: _getDateTime,
                  showSelected: showSelectedDates,
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

                    final userDate = FirebaseAuth.instance.currentUser;
                    final userId = userDate!.uid;
                    final userEmail = userDate.email ?? '';

                    final ref = FirebaseStorage.instance
                        .ref()
                        .child('profiles/$userId');
                    TaskSnapshot? imageRef;
                    if (imageFilePicked == null) {
                      if (_profileImage != null) {
                        final response =
                            await http.get(Uri.parse(_profileImage!));

                        final documentDirectory =
                            await getApplicationDocumentsDirectory();

                        final file =
                            File("${documentDirectory.path}imagetest.png");

                        file.writeAsBytesSync(response.bodyBytes);

                        imageRef = await ref.putFile(file).whenComplete(() {});
                      }
                    } else {
                      imageRef = await ref
                          .putFile(imageFilePicked!)
                          .whenComplete(() {});
                    }

                    final imageUrl = await imageRef?.ref.getDownloadURL();
                    var token = await message.getFirebaseToken();

                    final userModel = UserModel(
                      id: userId,
                      email: userEmail,
                      username: _userNameController.text.trim(),
                      dob: _selectedDob.toString(),
                      fcmToken: token,
                      name:
                          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()} ',
                      createdAt: DateTime.now().toIso8601String(),
                      bio: _bioController.text.trim(),
                      imageStr: imageUrl ?? "",
                      isOnline: false,
                    );

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .set(userModel.toMap());
                    ProfileScreenController controller =
                        Get.isRegistered<ProfileScreenController>()
                            ? Get.find<ProfileScreenController>()
                            : Get.put((ProfileScreenController()));
                    controller.setUserProfile(userModel);
                    Get.offAll(() => const DashBoard());
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
