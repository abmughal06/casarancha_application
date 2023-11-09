import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_card.dart';
import 'package:casarancha/widgets/primary_appbar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post_model.dart';
import '../../widgets/shared/skeleton.dart';

class SavedPostScreen extends StatelessWidget {
  const SavedPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel?>();
    final users = context.watch<List<UserModel>?>();
    return Scaffold(
      appBar: primaryAppbar(title: 'Saved Posts', elevation: 0.1),
      body: StreamProvider.value(
        value: DataProvider().posts(null),
        initialData: null,
        child: Consumer<List<PostModel>?>(
          builder: (context, posts, child) {
            if (posts == null || users == null || currentUser == null) {
              return const PostSkeleton();
            }
            var filterPost = posts
                .where(
                    (element) => currentUser.savedPostsIds.contains(element.id))
                .toList();

            List<UserModel> postCreator = [];
            for (var p in filterPost) {
              for (var u in users) {
                if (p.creatorId == u.id) {
                  postCreator.add(u);
                }
              }
            }
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 30),
              shrinkWrap: true,
              itemCount: filterPost.length,
              itemBuilder: (cotext, index) {
                return PostCard(
                  post: filterPost[index],
                  postCreator: postCreator[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
