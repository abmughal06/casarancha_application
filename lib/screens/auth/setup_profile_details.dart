import 'dart:developer';

import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/auth/providers/setup_profile_provider.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    final provider = Provider.of<SetupProfileProvider>(context, listen: false);
    if (user?.photoURL != null) {
      provider.profileImage = user?.photoURL;
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
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: Column(
        children: [
          Consumer<SetupProfileProvider>(builder: (context, provider, b) {
            return Expanded(
              child: ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  GestureDetector(
                    onTap: provider.getFromGallery,
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.passthrough,
                      children: [
                        provider.imageFilePicked != null
                            ? Container(
                                height: 120,
                                width: 120,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: FileImage(
                                            provider.imageFilePicked!))),
                              ) /* CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      Image.file(imageFilePicked!).image) */
                            : provider.profileImage != null
                                ? imgProVerified(
                                    profileImg: provider.profileImage,
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
                                            image: AssetImage(
                                                imgUserPlaceHolder))),
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
                        provider.bioTxtCount =
                            _bioController.text.length.toString();
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
                            text: "${provider.bioTxtCount}/300",
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
                ],
              ),
            );
          }),
          Consumer<SetupProfileProvider>(builder: (context, provider, b) {
            return Padding(
              padding: EdgeInsets.all(20.w),
              child: CommonButton(
                height: 56.h,
                text: 'Continue',
                showLoading: provider.isLoading,
                onTap: () async {
                  await provider.setupProfileData(
                    fname: _firstNameController.text,
                    lname: _lastNameController.text,
                    username: _userNameController.text,
                    bio: _bioController.text,
                  );
                },
                width: double.infinity,
              ),
            );
          }),
          heightBox(10.w)
        ],
      ),
    );
  }
}
