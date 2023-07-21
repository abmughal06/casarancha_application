import 'dart:developer';

import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_creator_prf_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/comment_model.dart';
import '../../widgets/home_screen_widgets/post_comment_field.dart';
import '../../widgets/home_screen_widgets/post_comment_tile.dart';
import '../../widgets/home_screen_widgets/post_detail_media.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({Key? key, required this.postModel}) : super(key: key);
  final PostModel postModel;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final coommenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

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
            ListView(
              children: [
                Consumer<List<PostModel>?>(
                  builder: (context, posts, b) {
                    if (posts == null) {
                      log(widget.postModel.id);
                      return const CircularProgressIndicator();
                    } else {
                      var post = posts
                          .where((element) => element.id == widget.postModel.id)
                          .first;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: post.mediaData[0].type == 'Photo'
                                ? 2 / 3
                                : post.mediaData[0].type == 'Video'
                                    ? 9 / 16
                                    : post.mediaData[0].type == 'Music'
                                        ? 13 / 9
                                        : 1 / 1,
                            child: Stack(
                              children: [
                                ListView.builder(
                                  itemCount: post.mediaData.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var mediaData = post.mediaData[index];
                                    return CheckMediaAndShowPost(
                                      ondoubleTap: () => postProvider
                                          .toggleLikeDislike(postModel: post),
                                      mediaData: mediaData,
                                      postId: widget.postModel.id,
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 60,
                                  left: 20,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.20),
                                    child: InkWell(
                                        child: const Icon(
                                          Icons.navigate_before,
                                          color: Colors.black,
                                        ),
                                        onTap: () => Get.back()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          PostCreatorProfileTile(post: post)
                        ],
                      );
                    }
                  },
                ),
                StreamProvider.value(
                  value: DataProvider().comment(widget.postModel.id),
                  initialData: null,
                  child: Consumer<List<Comment>?>(
                    builder: (context, comment, b) {
                      return comment == null
                          ? const CircularProgressIndicator()
                          : ListView.builder(
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
                                      : PostCommentTile(cmnt: cmnt);
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
            PostCommentField(
              postModel: widget.postModel,
              commentController: coommenController,
            )
          ],
        ),
      ),
    );
  }
}
