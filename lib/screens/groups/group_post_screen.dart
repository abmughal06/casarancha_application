// import 'package:casarancha/models/group_model.dart';
// import 'package:casarancha/screens/groups/group_member_screen.dart';
// import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
// import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
// import 'package:casarancha/utils/snackbar.dart';

// import 'package:casarancha/widgets/common_button.dart';
// import 'package:casarancha/widgets/custome_firebase_list_view.dart';

// import 'package:casarancha/widgets/primary_Appbar.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// import 'package:get/get.dart';

// import '../../models/post_model.dart';
// import '../../resources/image_resources.dart';
// import '../../widgets/PostCard/PostCardController.dart';

// class GroupPostScreen extends StatefulWidget {
//   const GroupPostScreen({Key? key, required this.group}) : super(key: key);

//   final GroupModel group;

//   @override
//   State<GroupPostScreen> createState() => _GroupPostScreenState();
// }

// class _GroupPostScreenState extends State<GroupPostScreen> {
//   late bool isJoined;
//   late bool isCreater;
//   bool isJoiningGroup = false;
//   bool isDeletingGroup = false;
//   final profileController = Get.find<ProfileScreenController>();

//   @override
//   void initState() {
//     super.initState();
//     isCreater = widget.group.creatorId == profileController.user.value.id;
//     isJoined = widget.group.memberIds.contains(profileController.user.value.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: primaryAppbar(
//         title: widget.group.name,
//         actions: [
//           isCreater
//               ? TextButton(
//                   onPressed: () async {
//                     setState(() {
//                       isDeletingGroup = true;
//                     });
//                     final userID = profileController.user.value.id;
//                     try {
//                       await FirebaseFirestore.instance
//                           .collection('groups')
//                           .doc(widget.group.id)
//                           .delete();
//                       Get.back();
//                     } catch (e) {
//                       GlobalSnackBar(message: e.toString());
//                     }

//                     setState(() {
//                       isDeletingGroup = false;
//                     });
//                   },
//                   child: isDeletingGroup
//                       ? const CircularProgressIndicator.adaptive()
//                       : Text('Delete'),
//                 )
//               : TextButton(
//                   onPressed: () async {
//                     setState(() {
//                       isJoiningGroup = true;
//                     });
//                     final userID = profileController.user.value.id;
//                     try {
//                       if (isJoined) {
//                         await FirebaseFirestore.instance
//                             .collection('users')
//                             .doc(userID)
//                             .update({
//                           'groupIds': FieldValue.arrayRemove([widget.group.id])
//                         });
//                         await FirebaseFirestore.instance
//                             .collection('groups')
//                             .doc(widget.group.id)
//                             .update({
//                           'memberIds': FieldValue.arrayRemove([userID])
//                         });
//                         isJoined = !isJoined;
//                       } else {
//                         if (!widget.group.isPublic) {
//                           GlobalSnackBar.show(
//                               message:
//                                   'Your request to join the group has been send');
//                           await FirebaseFirestore.instance
//                               .collection('groups')
//                               .doc(widget.group.id)
//                               .update({
//                             'joinRequestIds': FieldValue.arrayUnion([userID])
//                           });
//                         } else {
//                           await FirebaseFirestore.instance
//                               .collection('users')
//                               .doc(userID)
//                               .update({
//                             'groupIds': FieldValue.arrayUnion([widget.group.id])
//                           });
//                           await FirebaseFirestore.instance
//                               .collection('groups')
//                               .doc(widget.group.id)
//                               .update({
//                             'memberIds': FieldValue.arrayUnion([userID])
//                           });
//                           isJoined = !isJoined;
//                         }
//                       }
//                     } catch (e) {
//                       GlobalSnackBar(message: e.toString());
//                     }

//                     setState(() {
//                       isJoiningGroup = false;
//                     });
//                   },
//                   child: isJoiningGroup
//                       ? const CircularProgressIndicator.adaptive()
//                       : Text(
//                           isJoined ? 'Leave' : 'Join',
//                         ),
//                 ),
//           if (isJoined)
//             IconButton(
//               onPressed: () {
//                 Get.to(() => GroupMemberScreen(group: widget.group));
//               },
//               icon: SvgPicture.asset(
//                 icGroupMember,
//               ),
//             ),
//         ],
//       ),
//       body: ShowAllPost(
//         query: FirebaseFirestore.instance
//             .collection('groups')
//             .doc(widget.group.id)
//             .collection('posts')
//             .orderBy(
//               'createdAt',
//               descending: true,
//             ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: isJoined
//           ? Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 20.w,
//                 vertical: 10.w,
//               ),
//               child: CommonButton(
//                 height: 56.h,
//                 text: 'Post on Group',
//                 onTap: () {
//                   Get.to(() => CreatePostScreen(
//                         groupId: widget.group.id,
//                       ));
//                 },
//               ),
//             )
//           : null,
//     );
//   }
// }

// class ShowAllPost extends StatelessWidget {
//   const ShowAllPost({
//     Key? key,
//     required this.query,
//     this.physics,
//     this.shrinkWrap = false,
//   }) : super(key: key);

//   final Query<Map<String, dynamic>> query;
//   final ScrollPhysics? physics;
//   final bool shrinkWrap;

//   @override
//   Widget build(BuildContext context) {
//     return CustomeFirestoreListView(
//       shrinkWrap: shrinkWrap,
//       physics: physics,
//       query: query,
//       itemBuilder: (context, QueryDocumentSnapshot<Map<String, dynamic>> doc) {
//         final post = PostModel.fromMap(doc.data());
//         if ((post.reportCount ?? 0) <= 10) {
//           final postCardController = Get.put(
//             PostCardController(
//               postdata: post,
//             ),
//             tag: post.id,
//           );
//           // return NewPostCard(
//           //   postCardController: postCardController,
//           // );
//         }
//         return const SizedBox(height: 0, width: 0);
//       },
//     );
//   }
// }
