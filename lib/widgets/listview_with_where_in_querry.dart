// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:casarancha/models/post_model.dart';
// import 'package:casarancha/utils/snackbar.dart';
// import 'package:casarancha/widgets/PostCard/PostCardController.dart';
// import 'package:inview_notifier_list/inview_notifier_list.dart';

// class ListViewPostsWithWhereInQuerry extends StatefulWidget {
//   const ListViewPostsWithWhereInQuerry({
//     Key? key,
//     required this.listOfIds,
//     required this.controllerTag,
//     this.field = 'id',
//   }) : super(key: key);

//   final List<String> listOfIds;
//   final String field;
//   final String controllerTag;

//   @override
//   State<ListViewPostsWithWhereInQuerry> createState() =>
//       _ListViewWithWhereInQuerryState();
// }

// class _ListViewWithWhereInQuerryState
//     extends State<ListViewPostsWithWhereInQuerry> {
//   late ListViewWithWhereInQuerryController controller;
//   @override
//   void initState() {
//     controller = Get.put(
//       ListViewWithWhereInQuerryController(
//         listOfIds: widget.listOfIds,
//         field: widget.field,
//       ),
//       tag: widget.controllerTag,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => controller.isLoadingData.value
//           ? const Center(
//               child: CircularProgressIndicator.adaptive(),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: InViewNotifierList(
//                     isInViewPortCondition:
//                         (deltaTop, deltaBottom, viewPortDimension) {
//                       return deltaTop < (0.5 * viewPortDimension) &&
//                           deltaBottom > (0.5 * viewPortDimension);
//                     },
//                     controller: controller.scrollController,
//                     itemCount: controller.listOfPost.length,
//                     builder: (context, index) {
//                       final post = controller.listOfPost[index];
//                       final postCardController = Get.put(
//                         PostCardController(postdata: post),
//                         tag: post.id,
//                       );
//                       // return NewPostCard(
//                       //   postCardController: postCardController,
//                       // );
//                       return Container();
//                     },
//                   ),
//                 ),
//                 if (controller.isFetchingMoreData.value)
//                   const SizedBox(
//                     height: 200,
//                     width: double.infinity,
//                     child: Center(
//                       child: CircularProgressIndicator.adaptive(),
//                     ),
//                   )
//               ],
//             ),
//     );
//   }
// }

// class ListViewWithWhereInQuerryController extends GetxController {
//   ListViewWithWhereInQuerryController({
//     required this.field,
//     required this.listOfIds,
//   });
//   List<String> listOfIds;
//   final String field;

//   late ScrollController scrollController;
//   bool shoudNotFetchMore = false;

//   var isFetchingMoreData = false.obs;
//   var isLoadingData = false.obs;
//   int startIndex = 0;
//   int endIndex = 10;

//   List<String> list = [];

//   var listOfPost = <PostModel>[].obs;

//   @override
//   void onInit() async {
//     scrollController = ScrollController();

//     if (listOfIds.isEmpty) {
//       list = ['Placeholder'];
//     } else {
//       list = listOfIds.sublist(
//         startIndex,
//         listOfIds.length < 11 ? null : endIndex,
//       );
//     }

//     if (listOfIds.length < 11) {
//       shoudNotFetchMore = true;
//     }

//     await loadPosts();
//     scrollController.addListener(() {
//       if (scrollController.position.pixels ==
//           (scrollController.position.maxScrollExtent)) {
//         addMorePost();
//       }
//     });

//     super.onInit();
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> addMorePost() async {
//     if (shoudNotFetchMore) {
//       return;
//     }
//     isFetchingMoreData.value = true;

//     startIndex = startIndex + 10;

//     endIndex = endIndex + 10;
//     list = listOfIds.sublist(
//       startIndex,
//       list.length < 11 ? null : endIndex,
//     );

//     if (list.length < 11) {
//       shoudNotFetchMore = true;
//     }

//     List<PostModel> helperList = [];
//     try {
//       final ref = await FirebaseFirestore.instance
//           .collection('posts')
//           .where(field, whereIn: list)
//           .get();

//       for (var element in ref.docs) {
//         helperList.add(PostModel.fromMap(element.data()));
//       }
//       listOfPost.addAll(helperList);
//     } catch (e) {
//       GlobalSnackBar(message: e.toString());
//     }

//     isFetchingMoreData.value = false;
//   }

//   Future<void> loadPosts() async {
//     isLoadingData.value = true;
//     List<PostModel> helperList = [];
//     try {
//       final ref = await FirebaseFirestore.instance
//           .collection('posts')
//           .where(field, whereIn: list)
//           .get();

//       for (var element in ref.docs) {
//         helperList.add(PostModel.fromMap(element.data()));
//       }

//       listOfPost.assignAll(helperList);
//     } catch (e) {
//       GlobalSnackBar(message: e.toString());
//     }
//     isLoadingData.value = false;
//   }
// }
