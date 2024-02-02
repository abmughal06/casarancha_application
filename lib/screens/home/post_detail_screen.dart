import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_creator_prf_tile.dart';
import 'package:casarancha/widgets/shared/shimmer_list.dart';
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
          : NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: StreamProvider.value(
                    value: DataProvider().singlePost(
                        postId: widget.postModel.id, groupId: widget.groupId),
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
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  post.mediaData.first.type == 'Quote' ||
                                          post.mediaData.first.type == 'poll'
                                      ? PostMediaWidgetForQuoteAndPoll(
                                          post: post,
                                          isPostDetail: true,
                                          groupId: widget.groupId,
                                        )
                                      : PostMediaWidgetForOtherTypes(
                                          post: post,
                                          isPostDetail: true,
                                          groupId: widget.groupId,
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
                )
              ],
              body: Stack(
                children: [
                  widget.groupId != null
                      ? StreamProvider.value(
                          value: DataProvider().comment(
                              cmntId: widget.postModel.id,
                              groupId: widget.groupId),
                          initialData: null,
                          catchError: (context, error) => null,
                          child: StreamProvider.value(
                            value: DataProvider().singleGroup(widget.groupId),
                            initialData: null,
                            catchError: (context, error) => null,
                            child: Consumer2<List<Comment>?, GroupModel?>(
                              builder: (context, comment, group, b) {
                                if (comment == null || group == null) {
                                  return const ChatShimmerList();
                                }

                                var filterList = comment
                                    .where((element) => !group
                                        .banFromCmntUsersIds
                                        .contains(element.creatorId))
                                    .toList();

                                return ListView.builder(
                                  itemCount: filterList.length,
                                  padding: const EdgeInsets.only(
                                    bottom: 70,
                                  ),
                                  itemBuilder: (context, index) {
                                    var data = filterList[index];
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
                        )
                      : StreamProvider.value(
                          value: DataProvider().comment(
                              cmntId: widget.postModel.id,
                              groupId: widget.groupId),
                          initialData: null,
                          catchError: (context, error) => null,
                          child: Consumer<List<Comment>?>(
                            builder: (context, comment, b) {
                              if (comment == null) {
                                return const ChatShimmerList();
                              }

                              return ListView.builder(
                                itemCount: comment.length,
                                padding: const EdgeInsets.only(
                                  bottom: 70,
                                ),
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
                  PostCommentField(
                    postModel: widget.postModel,
                    groupId: widget.groupId,
                  )
                ],
              ),
            ),
    );
  }
}
