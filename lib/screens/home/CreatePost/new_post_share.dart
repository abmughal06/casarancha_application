import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_controller.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../resources/color_resources.dart';
import '../../../resources/localization_text_strings.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/text_editing_widget.dart';

class NewPostShareScreen extends StatelessWidget {
  const NewPostShareScreen({
    Key? key,
    required this.createPostController,
    this.groupId,
  }) : super(key: key);

  final String? groupId;

  final CreatePostMethods createPostController;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel?>();
    return Scaffold(
      appBar: primaryAppbar(
        title: 'New Post',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          Consumer<CreatePostMethods>(builder: (context, state, b) {
        return CommonButton(
          showLoading: state.isSharingPost,
          text: 'Share Post',
          height: 58.w,
          verticalOutMargin: 10.w,
          horizontalOutMargin: 10.w,
          onTap: () => user == null
              ? GlobalSnackBar.show(message: "Cannot post right now")
              : state.sharePost(
                  groupId: groupId,
                  user: user,
                ),
        );
      }),
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
                  controller: createPostController.captionController,
                  hintColor: color887,
                  hint: strWriteCaption,
                  color: colorFF4,
                  textInputType: TextInputType.multiline,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                heightBox(10.w),
                TextEditingWidget(
                  controller: createPostController.tagsController,
                  hintColor: color887,
                  hint: strTagPeople,
                  color: colorFF4,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(icTagPeople),
                  ),
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                heightBox(10.w),
                TextEditingWidget(
                  controller: createPostController.locationController,
                  hintColor: color887,
                  hint: strLocation,
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
                      title: const Text("Show post time"),
                      value: m.showPostTime,
                      onChanged: (value) {
                        // m.showPostTime = value;
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
