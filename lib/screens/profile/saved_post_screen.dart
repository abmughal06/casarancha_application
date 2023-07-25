import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_card.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post_model.dart';

class SavedPostScreen extends StatelessWidget {
  const SavedPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel?>();
    return Scaffold(
      appBar: primaryAppbar(title: 'Saved Posts', elevation: 0.1),
      body: Consumer<List<PostModel>?>(
        builder: (context, posts, child) {
          if (posts == null && currentUser == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          var filterPost = posts!
              .where(
                  (element) => currentUser!.savedPostsIds.contains(element.id))
              .toList();
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 30),
            shrinkWrap: true,
            itemCount: filterPost.length,
            itemBuilder: (cotext, index) {
              return PostCard(post: filterPost[index]);
            },
          );
        },
      ),
    );
  }
}
