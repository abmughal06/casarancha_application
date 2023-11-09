import 'dart:io';

import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/text_editing_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../resources/image_resources.dart';
import '../../../utils/snackbar.dart';
import '../../../widgets/primary_appbar.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({
    Key? key,
    this.isEducation = false,
    this.isUsername = false,
    this.isOrganization = false,
    this.isGroup = false,
    this.isForum = false,
    this.isWork = false,
  }) : super(key: key);

  final bool isEducation;
  final bool isUsername;
  final bool isOrganization;
  final bool isGroup;
  final bool isForum;
  final bool isWork;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String get title {
    if (widget.isEducation) {
      return 'Education';
    } else if (widget.isUsername) {
      return 'Username';
    } else if (widget.isForum) {
      return 'Forum';
    } else if (widget.isGroup) {
      return 'Group';
    } else if (widget.isOrganization) {
      return 'Organization';
    } else {
      return 'Work';
    }
  }

  String get discription {
    if (widget.isEducation) {
      return 'Please fill in the information below in order to verify your education status';
    } else if (widget.isUsername) {
      return 'Please fill in the information below in order to verify your username status';
    } else if (widget.isForum) {
      return 'Please fill in the information below in order to verify your forum name status';
    } else if (widget.isGroup) {
      return 'Please fill in the information below in order to verify your group name status';
    } else if (widget.isOrganization) {
      return 'Please fill in the information below in order to verify your organization status';
    } else {
      return 'Please fill in the information below in order to verify your work status';
    }
  }

  String get textFieldHint {
    if (widget.isEducation) {
      return 'School Name';
    } else if (widget.isUsername) {
      return 'Username';
    } else if (widget.isForum) {
      return 'Forum Name';
    } else if (widget.isGroup) {
      return 'Group Name';
    } else if (widget.isOrganization) {
      return 'Organization Name';
    } else {
      return 'Name of place of work';
    }
  }

  String get idName {
    if (widget.isEducation) {
      return 'School ID';
    } else if (widget.isUsername) {
      return 'ID';
    } else if (widget.isForum) {
      return 'ID';
    } else if (widget.isGroup) {
      return 'ID';
    } else if (widget.isOrganization) {
      return 'ID';
    } else {
      return 'Work ID';
    }
  }

  File? idFile;
  File? otherDocFile;
  final controller = TextEditingController();

  void pickIDPhoto() async {
    try {
      final pickedPhoto =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedPhoto != null) {
        CroppedFile? croppedImage = await ImageCropper().cropImage(
            sourcePath: pickedPhoto.path,
            aspectRatio: const CropAspectRatio(ratioX: 3.375, ratioY: 2.125));
        var image = File(croppedImage!.path);
        idFile = image;
        setState(() {});
      }
    } catch (e) {
      GlobalSnackBar.show(message: 'Operation Cancelled');
    }
  }

  void pickDocPhoto() async {
    try {
      final pickedPhoto =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedPhoto != null) {
        CroppedFile? croppedImage = await ImageCropper().cropImage(
            sourcePath: pickedPhoto.path,
            aspectRatio: const CropAspectRatio(ratioX: 3.375, ratioY: 2.125));
        var image = File(croppedImage!.path);
        otherDocFile = image;
        setState(() {});
      }
    } catch (e) {
      GlobalSnackBar.show(message: 'Operation Cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: '$title Verification', elevation: 0.2),
      body: ListView(
        padding: EdgeInsets.all(20.h),
        children: [
          TextWidget(
            text: discription,
            color: color55F,
          ),
          heightBox(12.h),
          TextEditingWidget(
            controller: controller,
            hint: textFieldHint,
            color: color887.withOpacity(0.1),
            isBorderEnable: true,
          ),
          heightBox(12.h),
          GestureDetector(
            onTap: () => pickIDPhoto(),
            child: idFile == null
                ? DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      child: SizedBox(
                        height: 160.h,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file_sharp, size: 50.h),
                            heightBox(10.h),
                            TextWidget(text: "Upload $idName"),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 190.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: FileImage(idFile!),
                          fit: BoxFit.cover,
                        )),
                  ),
          ),
          heightBox(12.h),
          GestureDetector(
            onTap: () => pickDocPhoto(),
            child: otherDocFile == null
                ? DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: SizedBox(
                        height: 160.h,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file_sharp, size: 50.h),
                            heightBox(10.h),
                            const TextWidget(
                              text: 'Upload Other Documents\n(Optional)',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 190.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: FileImage(otherDocFile!),
                          fit: BoxFit.cover,
                        )),
                  ),
          ),
          heightBox(12.h),
          CommonButton(
            text: 'Send for verification',
            fontSize: 13.sp,
            height: 52.h,
            onTap: () {
              if (controller.text.isNotEmpty && idFile != null) {
                Get.bottomSheet(
                  Container(
                    // height: 350.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(icBottomSheetScroller),
                        heightBox(15.h),
                        SvgPicture.asset(icReportPostDone),
                        heightBox(15.h),
                        TextWidget(
                          text:
                              "Your application is submitted for\n$title verification",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          fontSize: 18.sp,
                          color: const Color(0xff212121),
                        ),
                        heightBox(12.h),
                        TextWidget(
                          text: "We will contact you shortly",
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: const Color(0xff5f5f5f),
                        ),
                        heightBox(40.h)
                      ],
                    ),
                  ),
                );
              } else {
                GlobalSnackBar.show(
                    message: 'Please fill the required information first');
              }
            },
          )
        ],
      ),
    );
  }
}
