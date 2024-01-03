import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/screens/search/search_screen.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/profle_screen_widgets/follow_following_tile.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key, required this.currentUser});
  final UserModel currentUser;

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  var bioTxtCount = '';

  late TextEditingController _groupNameController;
  late TextEditingController _groupDescriptionController;
  late TextEditingController _searchControllr;

  bool isPublic = true;
  bool isCreatingGroup = false;

  @override
  void initState() {
    super.initState();

    _searchControllr = TextEditingController();
    _groupNameController = TextEditingController();
    _groupDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _searchControllr.dispose();
    _groupNameController.dispose();
    _groupDescriptionController.dispose();
  }

  List<String> membersIds = [];

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
    final prov = Provider.of<NewGroupProvider>(context);
    final searchProvider = Provider.of<SearchProvider>(context);
    return Scaffold(
      appBar: primaryAppbar(title: strCreateGroup, elevation: 0.2),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightBox(20.h),
                GestureDetector(
                  onTap: () => prov.getFromGallery(),
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
                            backgroundColor: color55F,
                            backgroundImage: prov.imageFilePicked != null
                                ? Image.file(prov.imageFilePicked!).image
                                : Image.asset(imgUserPlaceHolder).image,
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
                  // onEditingComplete: () => FocusScope.of(context).unfocus(),
                ),
                heightBox(20.w),
                TextFormField(
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
                        text:
                            "${bioTxtCount.isNotEmpty ? bioTxtCount : '0'}/100",
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
                heightBox(15.h),
                const Divider(
                  color: colorDD3,
                  height: 0.7,
                ),
                heightBox(15.h),
                TextWidget(
                  text: strAddMember,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: color221,
                ),
                heightBox(10.h),
                TextEditingWidget(
                  controller: _searchControllr,
                  hintColor: color080,
                  isShadowEnable: false,
                  hint: strSearch,
                  color: colorFF4,
                  prefixIcon: const Icon(Icons.search),
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChanged: (c) {
                    searchProvider.searchText(c);
                  },
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                ),
              ],
            ),
          ),
          Consumer<List<UserModel>?>(
            builder: (context, users, b) {
              if (users == null) {
                return centerLoader();
              }
              List<UserModel> filterList = users
                  .where((element) =>
                      widget.currentUser.followersIds.contains(element.id) ||
                      widget.currentUser.followingsIds.contains(element.id))
                  .toList();

              if (_searchControllr.text.isEmpty ||
                  _searchControllr.text == '') {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filterList.length,
                  padding:
                      const EdgeInsets.only(bottom: 100, left: 5, right: 5),
                  itemBuilder: (context, index) {
                    return FollowFollowingTile(
                      user: filterList[index],
                      ontapToggleFollow: () {
                        if (membersIds.contains(filterList[index].id)) {
                          membersIds.remove(filterList[index].id);
                        } else {
                          membersIds.add(filterList[index].id);
                        }
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      btnName: membersIds.contains(filterList[index].id)
                          ? strRemove
                          : strAdd,
                    );
                  },
                );
              }
              var searchList = filterList
                  .where((element) => element.name
                      .toLowerCase()
                      .contains(_searchControllr.text.toLowerCase()))
                  .toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchList.length,
                padding: const EdgeInsets.only(bottom: 100, left: 5, right: 5),
                itemBuilder: (context, index) {
                  return FollowFollowingTile(
                    user: searchList[index],
                    ontapToggleFollow: () {
                      if (membersIds.contains(searchList[index].id)) {
                        membersIds.remove(searchList[index].id);
                      } else {
                        membersIds.add(searchList[index].id);
                      }
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    btnName: membersIds.contains(searchList[index].id)
                        ? strRemove
                        : strAdd,
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20.w),
        child: CommonButton(
          showLoading: prov.isCreating,
          height: 56.h,
          text: strCreateGroup,
          width: double.infinity,
          onTap: () async => prov.createGroup(
              gName: _groupNameController.text,
              bio: _groupDescriptionController.text,
              isPublic: isPublic,
              currentUser: widget.currentUser,
              membersIds: membersIds + [widget.currentUser.id]),
        ),
      ),
    );
  }
}
