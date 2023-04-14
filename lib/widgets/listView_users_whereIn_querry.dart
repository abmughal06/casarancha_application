import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/widgets/app_user_tile.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:casarancha/utils/snackbar.dart';

class ListViewUsersWithWhereInQuerry extends StatefulWidget {
  const ListViewUsersWithWhereInQuerry({
    Key? key,
    required this.listOfIds,
    required this.controllerTag,
    this.isRequestedTile = false,
    this.groupId = '',
  }) : super(key: key);

  final bool isRequestedTile;
  final String groupId;

  final List<String> listOfIds;
  final String controllerTag;

  @override
  State<ListViewUsersWithWhereInQuerry> createState() =>
      _ListViewWithWhereInQuerryState();
}

class _ListViewWithWhereInQuerryState
    extends State<ListViewUsersWithWhereInQuerry> {
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
                      vertical: 20.w,
                    ),
                    controller: controller.scrollController,
                    itemCount: controller.listOfUsers.length,
                    itemBuilder: (context, index) {
                      final user = controller.listOfUsers[index];

                      return Column(
                        children: [
                          AppUserTile(
                            appUser: user,
                            currentUser:
                                Get.find<ProfileScreenController>().user.value,
                          ),
                          if (widget.isRequestedTile)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                acceptDeclineBtn(
                                  isAcceptBtn: true,
                                  onTap: () async {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.id)
                                        .update({
                                      'groupIds': FieldValue.arrayUnion(
                                          [widget.groupId])
                                    });
                                    FirebaseFirestore.instance
                                        .collection('groups')
                                        .doc(widget.groupId)
                                        .update({
                                      'memberIds': FieldValue.arrayUnion(
                                        [user.id],
                                      )
                                    });
                                    controller.listOfUsers.remove(user);
                                  },
                                ),
                                acceptDeclineBtn(
                                  isAcceptBtn: false,
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('groups')
                                        .doc(widget.groupId)
                                        .update({
                                      'joinRequestIds': FieldValue.arrayRemove(
                                        [user.id],
                                      ),
                                    });
                                    controller.listOfUsers.remove(user);
                                  },
                                ),
                              ],
                            ),
                        ],
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

  var listOfUsers = <UserModel>[].obs;

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

    List<UserModel> helperList = [];
    try {
      final ref = await FirebaseFirestore.instance
          .collection('users')
          .where('id', whereIn: list)
          .get();

      for (var element in ref.docs) {
        helperList.add(UserModel.fromMap(element.data()));
      }
      listOfUsers.addAll(helperList);
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }

    isFetchingMoreData.value = false;
  }

  Future<void> loadPosts() async {
    isLoadingData.value = true;
    List<UserModel> helperList = [];
    try {
      final ref = await FirebaseFirestore.instance
          .collection('users')
          .where('id', whereIn: list)
          .get();

      for (var element in ref.docs) {
        helperList.add(UserModel.fromMap(element.data()));
      }

      listOfUsers.assignAll(helperList);
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }
    isLoadingData.value = false;
  }
}
