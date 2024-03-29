import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_controller.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/profile_pic.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../resources/color_resources.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/text_editing_widget.dart';
import '../../../widgets/text_widget.dart';
import '../../search/search_screen.dart';

class NewPostShareScreen extends StatefulWidget {
  const NewPostShareScreen({
    super.key,
    this.groupId,
    required this.isPoll,
    required this.isForum,
    this.isGhostPost = false,
  });

  final String? groupId;
  final bool isPoll;
  final bool isForum;
  final bool isGhostPost;

  @override
  State<NewPostShareScreen> createState() => _NewPostShareScreenState();
}

class _NewPostShareScreenState extends State<NewPostShareScreen> {
  late CreatePostMethods createPostMethods;

  @override
  void dispose() {
    createPostMethods.selectedUsers.clear();
    createPostMethods.locationController.clear();
    createPostMethods.showPostTime = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel?>();
    // final allUsers = context.watch<List<UserModel>>();
    createPostMethods = Provider.of<CreatePostMethods>(context);

    return Scaffold(
      appBar: primaryAppbar(
        title: appText(context).strNewPost,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: user == null
          ? Container()
          : StreamProvider.value(
              value: DataProvider().filterUserList(
                  createPostMethods.selectedUsers.map((e) => e.id).toList()),
              catchError: (context, error) => null,
              initialData: null,
              child: Consumer<List<UserModel>?>(builder: (context, users, b) {
                if (users == null) {
                  return Container();
                }
                return CommonButton(
                  showLoading: createPostMethods.isSharingPost,
                  text: appText(context).strSharePost,
                  height: 58.w,
                  verticalOutMargin: 10.w,
                  horizontalOutMargin: 10.w,
                  onTap: () {
                    widget.isPoll
                        ? createPostMethods.sharePollPost(
                            user: user,
                          )
                        : createPostMethods.sharePost(
                            groupId: widget.groupId,
                            user: user,
                            isGhostPost: widget.isGhostPost,
                            isForum: widget.isForum,
                            tagIds: users.map((element) => element.id).toList(),
                            allUsers: users,
                          );
                    createPostMethods.selectedUsers.clear();
                  },
                );
              }),
            ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.w,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextEditingWidget(
                  controller: createPostMethods.captionController,
                  hintColor: color887,
                  hint: appText(context).strWriteCaption,
                  color: colorFF4,
                  textInputType: TextInputType.multiline,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                heightBox(10.w),
                InkWell(
                  onTap: () {
                    Get.to(() => const TagUserListDialog());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: colorFF4,
                      border: const Border.fromBorderSide(
                        BorderSide(color: Colors.transparent, width: 2.0),
                      ),
                    ),
                    child: Consumer<CreatePostMethods>(
                        builder: (context, prov, b) {
                      if (prov.selectedUsers.isEmpty) {
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset(icTagPeople),
                            ),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Tag People',
                                  style: TextStyle(color: color887),
                                )),
                          ],
                        );
                      }
                      return ListView.builder(
                          itemCount: prov.selectedUsers.length,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          itemBuilder: (context, index) {
                            var e = prov.selectedUsers[index];
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  decoration: BoxDecoration(
                                    color: colorPrimaryA05,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        e.username,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      widthBox(12.w),
                                      GestureDetector(
                                        onTap: () {
                                          createPostMethods.updateTagList(e);
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          });
                    }),
                  ),
                ),
                heightBox(10.w),
                TextEditingWidget(
                  controller: createPostMethods.locationController,
                  hintColor: color887,
                  hint: appText(context).strLocation,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(icLocationPost),
                  ),
                  color: colorFF4,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                ),
                heightBox(10.w),
                Consumer<CreatePostMethods>(
                  builder: (context, m, b) {
                    return SwitchListTile(
                      visualDensity: const VisualDensity(horizontal: -3),
                      title: Text(appText(context).strShowPstTime),
                      value: m.showPostTime,
                      onChanged: (value) {
                        m.togglePostTime();
                      },
                    );
                  },
                ),
                heightBox(10.w),
                Expanded(
                  child: Consumer<CreatePostMethods>(
                    builder: (context, state, b) {
                      return ListView.builder(
                        itemCount: state.mediaUploadTasks.length,
                        itemBuilder: (context, index) {
                          final UploadTask uploadTask =
                              state.mediaUploadTasks[index];

                          return StreamBuilder<TaskSnapshot>(
                            stream: uploadTask.snapshotEvents,
                            builder: (BuildContext context,
                                AsyncSnapshot<TaskSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!;
                                double progress =
                                    data.bytesTransferred / data.totalBytes;

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 8.h),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 10.h,
                                    semanticsLabel:
                                        '${(100 * progress).roundToDouble().toInt()}%',
                                  ),
                                );
                              } else {
                                return const SizedBox(
                                  height: 50,
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TagUserListDialog extends StatelessWidget {
  const TagUserListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<SearchProvider>(context);
    return Scaffold(
      appBar: primaryAppbar(
          title: appText(context).strSelectUsersTag, elevation: 0.2),
      body: Consumer<CreatePostMethods>(builder: (context, prov, b) {
        return Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            children: [
              searchTextField(
                context: context,
                controller: prov.tagsController,
                onChange: (value) {
                  search.searchText(value);
                },
              ),
              heightBox(10.h),
              StreamProvider.value(
                value: DataProvider().users(),
                initialData: null,
                catchError: (context, error) => null,
                child: Consumer<List<UserModel>?>(
                  builder: (context, users, b) {
                    if (prov.tagsController.text.isEmpty ||
                        prov.tagsController.text == '') {
                      return Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: TextWidget(
                              textAlign: TextAlign.center,
                              text: appText(context).strSearchUsers,
                            ),
                          ),
                        ),
                      );
                    }
                    var filterList = users!
                        .where((element) => (element.name
                                .toLowerCase()
                                .contains(
                                    prov.tagsController.text.toLowerCase()) ||
                            element.username.toLowerCase().contains(
                                prov.tagsController.text.toLowerCase())))
                        .toList();

                    return Expanded(
                      child: ListView.builder(
                        itemCount: filterList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          var userSnap = filterList[index];

                          return ListTile(
                              onTap: () {
                                prov.updateTagList(userSnap);

                                // printLog(prov.selectedUsers.toString());
                              },
                              title: Text(userSnap.username),
                              trailing: prov.selectedUsers.contains(userSnap)
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: colorPrimaryA05,
                                    )
                                  : null,
                              leading: ProfilePic(
                                pic: userSnap.imageStr,
                                heightAndWidth: 40.w,
                              ));
                        },
                        // FollowFollowingTile(
                        //   btnName: 'Nc',
                        //   user: userSnap,
                        //   ontapToggleFollow: () {},
                        // );
                      ),
                    );
                  },
                ),
              ),
              // heightBox(20.h),

              heightBox(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      // for (var user in prov.selectedUsers) {
                      //   printLog(
                      //       'Selected User ID: ${user.id}, Username: ${user.username}');
                      // }

                      Get.back(); // Close the dialog
                    },
                    child: Text(appText(context).strCancel),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle the selected users, update your UI accordingly
                      // updateTextFieldWithSelectedUsers(prov.selectedUsers);
                      Get.back(); // Close the dialog
                    },
                    child: Text(appText(context).strOk),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
