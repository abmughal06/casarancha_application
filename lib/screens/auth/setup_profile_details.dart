import 'dart:developer';

import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/auth/providers/setup_profile_provider.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../../utils/app_utils.dart';
import '../../utils/custom_date_picker.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/profle_screen_widgets/setup_profile_textfield.dart';
import '../../widgets/text_editing_widget.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _workController = TextEditingController();
  late SetupProfileProvider provider;

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    if (user?.displayName != null) {
      List<String> name = user!.displayName!.split(" ");

      if (name.isNotEmpty && name.length < 2) {
        _firstNameController.text = name[0];
      } else if (name.isNotEmpty && name.length < 3) {
        _firstNameController.text = name[0];
        _lastNameController.text = name[1];
      }
    }

    if (user!.email != null) {
      _userNameController.text = user.email!.split("@").first;
    }

    provider = Provider.of<SetupProfileProvider>(context, listen: false);
    if (user.photoURL != null) {
      provider.profileImage = user.photoURL;
    }
  }

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
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
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: Stack(
        children: [
          Consumer<SetupProfileProvider>(builder: (context, provider, b) {
            return Padding(
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 120.h,
                      width: 120.h,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: provider.getFromGallery,
                            child: Container(
                                height: 120.h,
                                width: 120.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: colorPrimaryA05, width: 1.5),
                                    image: provider.imageFilePicked != null
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                                provider.imageFilePicked!))
                                        : provider.profileImage != null
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    provider.profileImage!))
                                            : const DecorationImage(
                                                fit: BoxFit.fitHeight,
                                                image: AssetImage(
                                                    imgUserPlaceHolder)))),
                          ),
                          Positioned(
                            bottom: 2.h,
                            right: 3.h,
                            child: GestureDetector(
                              onTap: provider.getFromGallery,
                              child: SvgPicture.asset(
                                icProfileAdd,
                              ),
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
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
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
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    heightBox(10.w),
                    TextEditingWidget(
                      controller: _userNameController,
                      hintColor: color080,
                      isShadowEnable: false,
                      hint: strUserName,
                      maxLength: 150,
                      color: colorFF4,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    heightBox(10.w),
                    SetupProfileTextField(
                      controller: _bioController,
                      sizeHeight: 156.h,
                      onchange: (value) {
                        provider.bioTxtCount =
                            _bioController.text.length.toString();
                        setState(() {});
                      },
                      limitfield: 300,
                      hintText: strBio,
                      maxlines: 5,
                      countText: "${provider.bioTxtCount}/300",
                      inputHeight: 150,
                    ),
                    heightBox(10.w),
                    SetupProfileTextField(
                      controller: _educationController,
                      sizeHeight: 80.h,
                      onchange: (value) {
                        provider.educationTxtCount =
                            _educationController.text.length.toString();
                        setState(() {});
                      },
                      limitfield: 150,
                      hintText: strEducation,
                      maxlines: 3,
                      countText: "${provider.educationTxtCount}/300",
                      inputHeight: 100,
                    ),
                    heightBox(10.w),
                    SetupProfileTextField(
                      controller: _workController,
                      sizeHeight: 80.h,
                      onchange: (value) {
                        provider.workTxtCount =
                            _workController.text.length.toString();
                        setState(() {});
                      },
                      limitfield: 150,
                      hintText: strWork,
                      maxlines: 3,
                      countText: "${provider.workTxtCount}/300",
                      inputHeight: 100,
                    ),
                    heightBox(10.w),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Birthday',
                          style: TextStyle(
                            color: const Color(0xFF3B3B3B).withOpacity(0.8),
                            fontSize: 16.sp,
                            fontFamily: strFontName,
                            fontWeight: FontWeight.w300,
                          ),
                        )),
                    heightBox(5.w),
                    CustomDatePicker2(
                      getDateTime: provider.getDateTime,
                      showSelected: provider.showSelectedDates,
                      dateChangedCallback: (DateTime value) {
                        provider.getDateTime = value;
                        provider.selectedDob =
                            "${value.year}-${AppUtils.instance.convertSingleToTwoDigit(value.month.toString())}-${AppUtils.instance.convertSingleToTwoDigit(value.day.toString())}";
                        log("${provider.selectedDob}");
                      },
                    ),
                    heightBox(120.h)
                  ],
                ),
              ),
            );
          }),
          Positioned(
            bottom: 30,
            right: 5,
            left: 5,
            child:
                Consumer<SetupProfileProvider>(builder: (context, provider, b) {
              return Padding(
                padding: EdgeInsets.all(20.w),
                child: CommonButton(
                  height: 56.h,
                  text: strContinue,
                  showLoading: provider.isLoading,
                  onTap: () async {
                    await provider.setupProfileData(
                      fname: _firstNameController.text,
                      lname: _lastNameController.text,
                      username: _userNameController.text,
                      bio: _bioController.text,
                      education: _educationController.text,
                      work: _workController.text,
                    );
                    provider.disposeImage();
                  },
                  width: double.infinity,
                ),
              );
            }),
          ),
          heightBox(10.w)
        ],
      ),
    );
  }
}
