import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_creator_prf_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/comment_model.dart';
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

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.postModel.mediaData.isEmpty &&
              widget.postModel.commentIds.isEmpty
          ? const Center(
              child: Text('Post deleted'),
            )
          : Stack(
              children: [
                ListView(
                  controller: scrollController,
                  children: [
                    PDSPostCard(
                      postModel: widget.postModel,
                      groupId: widget.groupId,
                    ),
                    CommentsList(
                      postModel: widget.postModel,
                      groupId: widget.groupId,
                    )
                  ],
                ),
                PostCommentField(
                  postModel: widget.postModel,
                  groupId: widget.groupId,
                ),
              ],
            ),
    );
  }
}

class PDSPostCard extends StatelessWidget {
  const PDSPostCard({super.key, this.groupId, required this.postModel});
  final String? groupId;
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: DataProvider().singlePost(postId: postModel.id, groupId: groupId),
      initialData: null,
      catchError: (context, error) => null,
      child: Consumer<PostModel?>(
        builder: (context, post, b) {
          if (post == null) {
            return shimmerImg(
              height: 9 / 16,
              width: double.infinity,
              borderRadius: 12,
            );
          } else {
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    post.mediaData.first.type == 'Quote' ||
                            post.mediaData.first.type == 'poll'
                        ? PostMediaWidgetForQuoteAndPoll(
                            post: post,
                            isPostDetail: true,
                            groupId: groupId,
                          )
                        : PostMediaWidgetForOtherTypes(
                            post: post,
                            isPostDetail: true,
                            groupId: groupId,
                          ),
                    PostCreatorProfileTile(
                      post: post,
                      groupId: groupId,
                    ),
                  ],
                ),
                Positioned(
                  top: 20,
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
            );
          }
        },
      ),
    );
  }
}

class CommentsList extends StatelessWidget {
  const CommentsList({super.key, this.groupId, required this.postModel});
  final String? groupId;
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return groupId != null
        ? StreamProvider.value(
            value:
                DataProvider().comment(cmntId: postModel.id, groupId: groupId),
            initialData: null,
            catchError: (context, error) => null,
            child: StreamProvider.value(
              value: DataProvider().singleGroup(groupId),
              initialData: null,
              catchError: (context, error) => null,
              child: Consumer2<List<Comment>?, GroupModel?>(
                builder: (context, comment, group, b) {
                  if (comment == null || group == null) {
                    return Container();
                  }

                  var filterList = comment
                      .where((element) => !group.banFromCmntUsersIds
                          .contains(element.creatorId))
                      .toList();

                  return ListView.builder(
                    itemCount: filterList.length,
                    padding: const EdgeInsets.only(
                      bottom: 70,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = filterList[index];
                      var cmnt = data;
                      if (cmnt.creatorDetails.name.isNotEmpty) {
                        return cmnt.message.isEmpty
                            ? Container()
                            : PostCommentTile(
                                cmnt: cmnt,
                                postModel: postModel,
                                isFeedTile: false,
                                groupId: groupId,
                              );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              ),
            ),
          )
        : StreamProvider.value(
            value:
                DataProvider().comment(cmntId: postModel.id, groupId: groupId),
            initialData: null,
            catchError: (context, error) => null,
            child: Consumer<List<Comment>?>(
              builder: (context, comment, b) {
                if (comment == null) {
                  return Container();
                }

                return ListView.builder(
                  itemCount: comment.length,
                  padding: const EdgeInsets.only(
                    bottom: 70,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var data = comment[index];
                    var cmnt = data;
                    if (cmnt.creatorDetails.name.isNotEmpty) {
                      return cmnt.message.isEmpty
                          ? Container()
                          : PostCommentTile(
                              cmnt: cmnt,
                              postModel: postModel,
                              isFeedTile: false,
                              groupId: groupId,
                            );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
          );
  }
}
