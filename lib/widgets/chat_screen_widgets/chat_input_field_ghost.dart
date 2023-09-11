// import 'dart:developer';

// import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
// import 'package:casarancha/widgets/chat_screen_widgets/chat_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// import '../../../models/user_model.dart';
// import '../../../resources/color_resources.dart';
// import '../../../resources/image_resources.dart';
// import '../../../widgets/common_widgets.dart';

// class ChatInputFieldGhost extends StatelessWidget {
//   const ChatInputFieldGhost(
//       {Key? key,
//       required this.currentUser,
//       required this.appUser,
//       required this.onTapSentMessage})
//       : super(key: key);
//   final UserModel currentUser;
//   final UserModel appUser;
//   final VoidCallback onTapSentMessage;

//   @override
//   Widget build(BuildContext context) {
//     bool isRecordingDelete = false;
//     return Consumer<ChatProvider>(
//       builder: (context, chatProvider, b) {
//         return chatProvider.photosList.isNotEmpty ||
//                 chatProvider.videosList.isNotEmpty ||
//                 chatProvider.mediaList.isNotEmpty ||
//                 chatProvider.musicList.isNotEmpty
//             ? ShowMediaToSendInChat(
//                 currentUser: currentUser,
//                 appUser: appUser,
//               )
//             : Container(
//                 decoration: BoxDecoration(
//                     color: colorWhite,
//                     border: Border(
//                         top: BorderSide(color: color221.withOpacity(0.3)))),
//                 padding: const EdgeInsets.only(
//                     left: 20, right: 20, bottom: 35, top: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Visibility(
//                       visible: !chatProvider.isRecording &&
//                           !chatProvider.isRecordingSend,
//                       child: Expanded(
//                         child: ChatTextField(
//                           chatController: chatProvider.messageController,
//                           ontapSend: () {},
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: chatProvider.isRecording ||
//                           chatProvider.isRecordingSend,
//                       child: VoiceRecordingWidget(
//                           sendRecording: () => chatProvider.stopRecording(
//                                 currentUser: currentUser,
//                                 appUser: appUser,
//                               ),
//                           isRecorderLock: chatProvider.isRecorderLock,
//                           onTapDelete: () => chatProvider.deleteRecording(),
//                           isRecording: chatProvider.isRecording,
//                           isRecordingSend: chatProvider.isRecordingSend,
//                           duration: formatTime(chatProvider.durationInSeconds)),
//                     ),
//                     Visibility(
//                       visible: chatProvider.messageController.text.isEmpty,
//                       child: Row(
//                         children: [
//                           widthBox(12.w),
//                           chatProvider.isRecorderLock
//                               ? GestureDetector(
//                                   onTap: () {
//                                     chatProvider.stopRecording(
//                                       currentUser: currentUser,
//                                       appUser: appUser,
//                                     );
//                                   },
//                                   child: Image.asset(
//                                     imgSendComment,
//                                     height: 38.h,
//                                     width: 38.w,
//                                   ),
//                                 )
//                               : GestureDetector(
//                                   onLongPressStart: (c) async {
//                                     if (await chatProvider.audioRecorder
//                                         .hasPermission()) {
//                                       chatProvider.startRecording();
//                                     }
//                                     isRecordingDelete = false;
//                                   },
//                                   onLongPressMoveUpdate: (details) {
//                                     final dragDistanceHor =
//                                         details.localPosition.dx;
//                                     final dragDistanceVer =
//                                         details.localPosition.dy;

//                                     if (dragDistanceHor < -50) {
//                                       chatProvider.deleteRecording();
//                                       log('deleted');
//                                       isRecordingDelete = true;
//                                     }
//                                     if (dragDistanceVer < -20) {
//                                       chatProvider.toggleRecorderLock();
//                                     }
//                                   },
//                                   onLongPressEnd: (details) {
//                                     if (!isRecordingDelete) {
//                                       chatProvider.stopRecording(
//                                         currentUser: currentUser,
//                                         appUser: appUser,
//                                       );
//                                       log('stopped');
//                                     }
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(8.w),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: colorF03.withOpacity(0.6)),
//                                     child: const Icon(
//                                       Icons.mic_none_sharp,
//                                       color: color221,
//                                     ),
//                                   ),
//                                 )
//                         ],
//                       ),
//                     ),
//                     Visibility(
//                       visible: chatProvider.messageController.text.isNotEmpty &&
//                           !chatProvider.isRecording,
//                       child: Row(
//                         children: [
//                           widthBox(12.w),
//                           GestureDetector(
//                             onTap: onTapSentMessage,
//                             child: Image.asset(
//                               imgSendComment,
//                               height: 38.h,
//                               width: 38.w,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               );
//       },
//     );
//   }
// }
