import 'dart:io';

import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key, required this.currentUser})
      : super(key: key);
  final UserModel currentUser;

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  var bioTxtCount = '';

  late TextEditingController _groupNameController;
  late TextEditingController _groupDescriptionController;

  bool isPublic = true;
  bool isCreatingGroup = false;

  File? imageFilePicked;

  @override
  void initState() {
    _groupNameController = TextEditingController();
    _groupDescriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupDescriptionController.dispose();
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
      imageFilePicked = File(pickedFile.path);
      setState(() {});
    } else {
      GlobalSnackBar.show(message: 'Process Cancelled');
    }
  }

  Widget grpTypeBtn(
      {required bool isSelected,
      required String strText,
      GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 33.h,
        width: 160.w,
        decoration: BoxDecoration(
          color: isSelected ? colorF03 : colorFF4,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Row(
          children: [
            widthBox(10.w),
            SvgPicture.asset(isSelected ? icGroupTypeSel : icGroupTypeDeSel),
            widthBox(6.w),
            TextWidget(
              text: strText,
              fontWeight: FontWeight.w500,
              color: isSelected ? color13F : color55F,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: strCreateGroup),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          GestureDetector(
            onTap: () => _getFromGallery(),
            child: Center(
              child: SizedBox(
                height: 127.h,
                width: 127.w,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: imageFilePicked != null
                          ? Image.file(imageFilePicked!).image
                          : Image.asset(imgProfile).image,
                    ),
                    Positioned(
                      bottom: 0.h,
                      right: 5.w,
                      child: SvgPicture.asset(
                        icAddGroupDp,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          heightBox(20.w),
          TextEditingWidget(
            controller: _groupNameController,
            hintColor: color080,
            isShadowEnable: false,
            hint: strGroupName,
            color: colorFF4,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onEditingComplete: () => FocusScope.of(context).unfocus(),
          ),
          heightBox(20.w),
          SizedBox(
            height: 156.h,
            child: TextFormField(
              controller: _groupDescriptionController,
              onChanged: (value) {
                bioTxtCount =
                    _groupDescriptionController.text.length.toString();
                setState(() {});
              },
              style: TextStyle(
                color: color239,
                fontSize: 16.sp,
                fontFamily: strFontName,
                fontWeight: FontWeight.w600,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
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
                    text: "$bioTxtCount/100",
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
          heightBox(20.w),
          const TextWidget(
            text: strKeepInGrp,
            fontWeight: FontWeight.w500,
            color: color221,
          ),
          heightBox(20.w),
          Row(
            children: [
              grpTypeBtn(
                  isSelected: isPublic,
                  strText: strPublic,
                  onTap: () {
                    setState(() {
                      isPublic = true;
                    });
                  }),
              widthBox(8.w),
              grpTypeBtn(
                isSelected: !isPublic,
                strText: strPrivate,
                onTap: () {
                  setState(() {
                    isPublic = false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20.w),
        child: CommonButton(
          showLoading: isCreatingGroup,
          height: 56.h,
          text: strCreateGroup,
          width: double.infinity,
          onTap: () async {
            var groupName = _groupNameController.text.trim();
            var groupDescription = _groupDescriptionController.text.trim();
            if (groupName.isEmpty) {
              const GlobalSnackBar(message: 'Please write group name');
              return;
            }
            if (groupDescription.isEmpty) {
              const GlobalSnackBar(message: 'Please write group description');
              return;
            }
            if (imageFilePicked == null) {
              const GlobalSnackBar(message: 'Please provide group image');
              return;
            }

            setState(() {
              isCreatingGroup = true;
            });

            final groupRef =
                FirebaseFirestore.instance.collection('groups').doc();

            final ref = FirebaseStorage.instance
                .ref()
                .child('groupImages/${groupRef.id}');

            try {
              final imageRef =
                  await ref.putFile(imageFilePicked!).whenComplete(() {});

              final imageUrl = await imageRef.ref.getDownloadURL();

              final GroupModel group = GroupModel(
                id: groupRef.id,
                name: groupName,
                description: groupDescription,
                imageUrl: imageUrl,
                creatorId: widget.currentUser.id,
                creatorDetails: CreatorDetails(
                  name: widget.currentUser.name,
                  imageUrl: widget.currentUser.imageStr,
                  isVerified: widget.currentUser.isVerified,
                ),
                createdAt: DateTime.now().toIso8601String(),
                isPublic: isPublic,
                memberIds: [widget.currentUser.id],
                joinRequestIds: [],
              );

              await groupRef.set(group.toMap());
              Get.back();
            } catch (e) {
              GlobalSnackBar.show(message: e.toString());
            }
            setState(() {
              isCreatingGroup = false;
            });
          },
        ),
      ),
    );
  }
}
