import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';

import '../../utils/app_utils.dart';
import '../../utils/custom_date_picker.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';
import 'ProfileScreen/provider/edit_profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // late EditProfileProvider edit;

  @override
  Widget build(BuildContext context) {
    final edit = Provider.of<EditProfileProvider>(context);
    // final currentUser = context.watch<UserModel?>();
    return Scaffold(
      appBar: primaryAppbar(
        title: 'Setup Profile',
        showBackButton: true,
        elevation: 0,
      ),
      body: Consumer<UserModel?>(builder: (context, user, b) {
        if (user == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        edit.firstNameController =
            TextEditingController(text: user.name.split(" ").first);
        edit.lastNameController =
            TextEditingController(text: user.name.split(" ")[1]);
        edit.bioController = TextEditingController(text: user.bio);
        edit.educationController = TextEditingController(text: user.education);
        edit.workController = TextEditingController(text: user.work);
        edit.userNameController = TextEditingController(text: user.username);
        edit.selectedDob = user.dob;
        edit.getDateTime = DateTime.parse(edit.selectedDob!);
        edit.bioTxtCount = user.bio.length.toString();
        edit.educationTxtCount = user.education.length.toString();
        edit.workTxtCount = user.work.length.toString();
        edit.profileImage = user.imageStr;
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 127.h,
                      width: 127.w,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.passthrough,
                        children: [
                          edit.imageFilePicked != null
                              ? Container(
                                  height: 127.h,
                                  width: 127.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                              edit.imageFilePicked!))),
                                )
                              : edit.profileImage != null
                                  ? edit.profileImage != ''
                                      ? Container(
                                          height: 127.h,
                                          width: 127.h,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  edit.profileImage!),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 127.h,
                                          width: 127.h,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  imgUserPlaceHolder),
                                            ),
                                          ),
                                        )
                                  : CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          Image.asset(imgProfile).image,
                                    ),
                          Positioned(
                            bottom: 0.h,
                            right: 0.w,
                            child: GestureDetector(
                              onTap: () => edit.getFromGallery(),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: colorWhite,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(3.w),
                                child: SvgPicture.asset(
                                  icProfileAdd,
                                  height: 35.h,
                                  width: 35.h,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  heightBox(20.w),
                  TextEditingWidget(
                    controller: edit.firstNameController,
                    hintColor: color080,
                    isShadowEnable: false,
                    hint: appText(context).strFirstName,
                    color: colorFF4,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  heightBox(10.w),
                  TextEditingWidget(
                    controller: edit.lastNameController,
                    hintColor: color080,
                    isShadowEnable: false,
                    hint: appText(context).strLastName,
                    color: colorFF4,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  heightBox(10.w),
                  TextEditingWidget(
                    controller: edit.userNameController,
                    hintColor: color080,
                    isShadowEnable: false,
                    hint: appText(context).strUserName,
                    maxLength: 150,
                    color: colorFF4,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  heightBox(10.w),
                  TextEditingWidget(
                    controller: edit.bioController,
                    hintColor: color080,
                    isShadowEnable: false,
                    hint: appText(context).strBio,
                    maxLength: 300,
                    maxLines: 5,
                    color: colorFF4,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  heightBox(10.w),
                  TextEditingWidget(
                    controller: edit.educationController,
                    hintColor: color080,
                    isShadowEnable: false,
                    hint: appText(context).strEducation,
                    maxLength: 150,
                    maxLines: 2,
                    color: colorFF4,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  heightBox(10.w),
                  TextEditingWidget(
                    controller: edit.workController,
                    hintColor: color080,
                    isShadowEnable: false,
                    hint: appText(context).strWork,
                    maxLength: 150,
                    maxLines: 2,
                    color: colorFF4,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  heightBox(10.w),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextWidget(
                      text: appText(context).strBirthday,
                      color: const Color(0xFF3B3B3B).withOpacity(0.8),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  heightBox(5.w),
                  CustomDatePicker(
                    getDateTime: edit.getDateTime,
                    showSelected: edit.showSelectedDates,
                    userDateTime: user.dob,
                    dateChangedCallback: (DateTime value) {
                      // _getDateTime = value;
                      edit.selectedDob =
                          "${value.year}-${AppUtils.instance.convertSingleToTwoDigit(value.month.toString())}-${AppUtils.instance.convertSingleToTwoDigit(value.day.toString())}";
                      edit.getDateTime = DateTime.parse(edit.selectedDob!);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: CommonButton(
                height: 56.h,
                text: appText(context).strSave,
                showLoading: edit.isLoading,
                onTap: () => edit.updateData(currentUser: user),
                width: double.infinity,
              ),
            ),
            heightBox(10.w)
          ],
        );
      }),
    );
  }
}
