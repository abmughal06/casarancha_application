import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';

import 'package:casarancha/widgets/listView_with_whereIn_querry.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SavedPostScreen extends StatelessWidget {
  SavedPostScreen({Key? key}) : super(key: key);
  final profileScreenController = Get.find<ProfileScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: 'Saved Posts'),
      body: ListViewPostsWithWhereInQuerry(
        listOfIds: profileScreenController.user.value.savedPostsIds,
        controllerTag: 'SavedPosts',
      ),
    );
  }
}
