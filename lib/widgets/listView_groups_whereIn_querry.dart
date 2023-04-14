import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/widgets/group_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';

import 'PostCard/PostCard.dart';

class ListViewGroupsWithWhereInQuerry extends StatefulWidget {
  const ListViewGroupsWithWhereInQuerry({
    Key? key,
    required this.listOfIds,
    required this.controllerTag,
  }) : super(key: key);

  final List<String> listOfIds;
  final String controllerTag;

  @override
  State<ListViewGroupsWithWhereInQuerry> createState() =>
      _ListViewWithWhereInQuerryState();
}

class _ListViewWithWhereInQuerryState
    extends State<ListViewGroupsWithWhereInQuerry> {
  late ListViewWithWhereInQuerryController controller;
  @override
  void initState() {
    controller = Get.put(
      ListViewWithWhereInQuerryController(
        listOfIds: widget.listOfIds,
      ),
      tag: widget.controllerTag,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoadingData.value
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.w,
                    ),
                    controller: controller.scrollController,
                    itemCount: controller.listOfGroups.length,
                    itemBuilder: (context, index) {
                      final group = controller.listOfGroups[index];

                      return GroupTile(
                        group: group,
                        currentUserId:
                            Get.find<ProfileScreenController>().user.value.id,
                      );
                    },
                  ),
                ),
                if (controller.isFetchingMoreData.value)
                  const SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
              ],
            ),
    );
  }
}

class ListViewWithWhereInQuerryController extends GetxController {
  ListViewWithWhereInQuerryController({
    required this.listOfIds,
  });
  List<String> listOfIds;

  late ScrollController scrollController;
  bool shoudNotFetchMore = false;

  var isFetchingMoreData = false.obs;
  var isLoadingData = false.obs;
  int startIndex = 0;
  int endIndex = 10;

  List<String> list = [];

  var listOfGroups = <GroupModel>[].obs;

  @override
  void onInit() async {
    scrollController = ScrollController();

    if (listOfIds.isEmpty) {
      list = ['Placeholder'];
    } else {
      list = listOfIds.sublist(
        startIndex,
        listOfIds.length < 11 ? null : endIndex,
      );
    }

    if (listOfIds.length < 11) {
      shoudNotFetchMore = true;
    }

    await loadPosts();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          (scrollController.position.maxScrollExtent)) {
        addMorePost();
      }
    });

    super.onInit();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> addMorePost() async {
    if (shoudNotFetchMore) {
      return;
    }
    isFetchingMoreData.value = true;

    startIndex = startIndex + 10;

    endIndex = endIndex + 10;
    list = listOfIds.sublist(
      startIndex,
      list.length < 11 ? null : endIndex,
    );

    if (list.length < 11) {
      shoudNotFetchMore = true;
    }

    List<GroupModel> helperList = [];
    try {
      final ref = await FirebaseFirestore.instance
          .collection('groups')
          .where('id', whereIn: list)
          .get();

      for (var element in ref.docs) {
        helperList.add(GroupModel.fromMap(element.data()));
      }
      listOfGroups.addAll(helperList);
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }

    isFetchingMoreData.value = false;
  }

  Future<void> loadPosts() async {
    isLoadingData.value = true;
    List<GroupModel> helperList = [];
    try {
      final ref = await FirebaseFirestore.instance
          .collection('groups')
          .where('id', whereIn: list)
          .get();

      for (var element in ref.docs) {
        helperList.add(GroupModel.fromMap(element.data()));
      }

      listOfGroups.assignAll(helperList);
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }
    isLoadingData.value = false;
  }
}
