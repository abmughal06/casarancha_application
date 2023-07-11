// import 'package:casarancha/screens/chat/GhostMode/ghost_chat_helper.dart';
// import 'package:casarancha/screens/chat/GhostMode/ghost_chat_screen.dart';
// import 'package:casarancha/screens/chat/GhostMode/ghost_conversation_model.dart';
// import 'package:casarancha/screens/chat/GhostMode/ghost_message_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';

// import '../../../resources/color_resources.dart';
// import '../../../resources/image_resources.dart';
// import '../../../widgets/common_widgets.dart';
// import '../../../widgets/text_widget.dart';

// class GhostModeInbox extends StatefulWidget {
//   const GhostModeInbox({Key? key}) : super(key: key);

//   @override
//   State<GhostModeInbox> createState() => _GhostModeInboxState();
// }

// class _GhostModeInboxState extends State<GhostModeInbox> {
//   final TextEditingController _searchTextController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<GhostMessageController>(
//       init: Get.isRegistered<GhostMessageController>()
//           ? Get.find<GhostMessageController>()
//           : Get.put(GhostMessageController()),
//       builder: (gmCtrl) {
//         return Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               child: searchTextField(
//                   context: context,
//                   controller: _searchTextController,
//                   onChange: (value) {
//                     //search on write > 3
//                     /* if (_searchTextController.text.trim().toLowerCase().length >
//                         2) {
//                       gmCtrl.changeSearchQuery(_searchTextController.text);
//                     } else if (_searchTextController.text.isEmpty) {
//                       gmCtrl.changeSearchQuery(null);
//                     } */
//                     if (_searchTextController.text.isEmpty) {
//                       gmCtrl.changeSearchQuery(null);
//                     }
//                   },
//                   onFieldSubmitted: (value) {
//                     if (_searchTextController.text.trim().isNotEmpty) {
//                       gmCtrl.changeSearchQuery(_searchTextController.text);
//                     }
//                   },
//                   suffixIcon: IconButton(
//                       onPressed: () {
//                         if (_searchTextController.text.trim().isNotEmpty) {
//                           gmCtrl.changeSearchQuery(null);
//                         }
//                         FocusScope.of(context).unfocus();
//                         _searchTextController.clear();
//                       },
//                       icon: Icon(
//                         Icons.close_rounded,
//                         color: Colors.grey.shade700,
//                       ))),
//             ),
//             heightBox(10.h),
//             Expanded(
//               child: ListView.builder(
//                   itemBuilder: (context, index) {
//                     return ghostInboxTile(gmCtrl.arrFriends[index]);
//                   },
//                   itemCount: gmCtrl.arrFriends.length),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget ghostInboxTile(GhostConversationModel gmConversation) {
//     DateTime now = DateTime.now();
//     DateTime time = gmConversation.messageCreatedAt != null
//         ? DateTime.fromMicrosecondsSinceEpoch(gmConversation.messageCreatedAt!)
//         : now;
//     String stringTime = (time.day == now.day &&
//             time.month == now.month &&
//             time.year == now.year)
//         ? GhostChatHelper.shared
//             .convertTimeStampToHumanHour(gmConversation.messageCreatedAt!)
//         : GhostChatHelper.shared
//             .convertTimeStampToHumanDate(gmConversation.messageCreatedAt!);
//     return Column(
//       children: [
//         ListTile(
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
//           onTap: () => Get.to(
//             () => GhostChatScreen(
//               receiverUserId: gmConversation.receiverId,
//               chatId: gmConversation.chatId,
//               name: "Ghost-${gmConversation.receiverHashId ?? ""}",
//             ),
//           ),
//           leading: const CircleAvatar(
//             maxRadius: 30,
//             backgroundColor: Colors.transparent,
//             backgroundImage: AssetImage(imgGhostUser),
//           ),
//           title: Row(
//             children: [
//               Expanded(
//                   child: Text("Ghost-${gmConversation.receiverHashId ?? ""}")),
//               SizedBox(
//                 width: 60,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextWidget(
//                       text: stringTime,
//                       color: Colors.black,
//                       fontSize: 13.sp,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           subtitle: Text(
//             gmConversation.lastMessage ?? "",
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(fontSize: 15.sp),
//           ),
//         ),
//         Divider(
//           height: 0,
//           color: Colors.grey.shade400,
//           endIndent: 10,
//           indent: 10,
//         )
//       ],
//     );
//   }
// }
