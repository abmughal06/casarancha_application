import 'dart:developer';

import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_creator_prf_tile.dart';
import 'package:casarancha/widgets/shared/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/comment_model.dart';
import '../../models/user_model.dart';
import '../../widgets/home_screen_widgets/post_comment_field.dart';
import '../../widgets/home_screen_widgets/post_comment_tile.dart';
import '../../widgets/home_screen_widgets/post_detail_media.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.postModel, this.groupId});
  final PostModel postModel;
  final String? groupId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final coommenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final users = context.watch<List<UserModel>?>();
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  StreamProvider.value(
                    value: DataProvider().singlePost(
                        postId: widget.postModel.id, groupId: widget.groupId),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<PostModel?>(
                      builder: (context, post, b) {
                        if (post == null) {
                          log(widget.postModel.id);
                          return const Skeleton(
                            height: 9 / 16,
                            width: double.infinity,
                            radius: 12,
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  PostMediaWidget(
                                    groupId: widget.groupId,
                                    post: post,
                                    isPostDetail: true,
                                  ),
                                  Positioned(
                                    top: 60,
                                    left: 20,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade50,
                                      child: InkWell(
                                        child: SvgPicture.asset(
                                          icIosBackArrow,
                                          color: Colors.black,
                                        ),
                                        onTap: () => Get.back(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              PostCreatorProfileTile(
                                post: post,
                                groupId: widget.groupId,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  StreamProvider.value(
                    value: DataProvider().comment(
                        cmntId: widget.postModel.id, groupId: widget.groupId),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<List<Comment>?>(
                      builder: (context, comment, b) {
                        if (comment == null || users == null) {
                          return const CircularProgressIndicator.adaptive();
                        }

                        return ListView.builder(
                          itemCount: comment.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 24),
                          itemBuilder: (context, index) {
                            var data = comment[index];
                            var cmnt = data;
                            if (cmnt.creatorDetails.name.isNotEmpty) {
                              return cmnt.message.isEmpty
                                  ? Container()
                                  : PostCommentTile(
                                      cmnt: cmnt,
                                      postModel: widget.postModel,
                                      isFeedTile: false,
                                      groupId: widget.groupId,
                                    );
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    ),
                  ),
                  heightBox(70.h),
                ],
              ),
            ),
            PostCommentField(
              postModel: widget.postModel,
              groupId: widget.groupId,
              commentController: postProvider.postCommentController,
            )
          ],
        ),
      ),
    );
  }
}
