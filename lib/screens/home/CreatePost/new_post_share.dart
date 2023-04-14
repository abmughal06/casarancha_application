import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_controller.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../resources/color_resources.dart';
import '../../../resources/localization_text_strings.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/text_editing_widget.dart';

class NewPostShareScreen extends StatefulWidget {
  const NewPostShareScreen({
    Key? key,
    required this.createPostController,
    this.groupId,
  }) : super(key: key);

  final String? groupId;

  final CreatePostController createPostController;

  @override
  State<NewPostShareScreen> createState() => _NewPostShareScreenState();
}

class _NewPostShareScreenState extends State<NewPostShareScreen> {
  bool showPostTime = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(
        title: 'New Post',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(
        () => CommonButton(
          showLoading: widget.createPostController.isSharingPost.value,
          text: 'Share Post',
          height: 58.w,
          verticalOutMargin: 10.w,
          horizontalOutMargin: 10.w,
          onTap: () => widget.createPostController
              .sharePost(groupId: widget.groupId, showPostTime: showPostTime),
        ),
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
                  controller: widget.createPostController.captionController,
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
                  controller: widget.createPostController.tagsController,
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
                  controller: widget.createPostController.locationController,
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
                SwitchListTile(
                    visualDensity: const VisualDensity(horizontal: -3),
                    title: const Text("Show post time"),
                    value: showPostTime,
                    onChanged: (value) {
                      showPostTime = value;
                      setState(() {});
                    }),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount:
                          widget.createPostController.mediaUploadTasks.length,
                      itemBuilder: (context, index) {
                        final UploadTask uploadTask =
                            widget.createPostController.mediaUploadTasks[index];

                        return StreamBuilder<TaskSnapshot>(
                          stream: uploadTask.snapshotEvents,
                          builder: (BuildContext context,
                              AsyncSnapshot<TaskSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!;
                              double progress =
                                  data.bytesTransferred / data.totalBytes;

                              return Stack(
                                children: [
                                  LinearProgressIndicator(
                                    value: progress,
                                  ),
                                  Center(
                                    child: Text(
                                      '${(100 * progress).roundToDouble()}%',
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return const SizedBox(
                                height: 50,
                              );
                            }
                          },
                        );
                      },
                    ),
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
