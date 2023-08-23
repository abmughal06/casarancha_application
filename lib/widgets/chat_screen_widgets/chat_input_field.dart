import 'dart:developer';

import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_text_field.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../models/user_model.dart';
import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/clip_pad_shadow.dart';
import '../../../widgets/common_widgets.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField(
      {Key? key,
      required this.currentUser,
      required this.appUser,
      required this.onTapSentMessage})
      : super(key: key);
  final UserModel currentUser;
  final UserModel appUser;
  final VoidCallback onTapSentMessage;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, b) {
        return chatProvider.photosList.isNotEmpty ||
                chatProvider.videosList.isNotEmpty ||
                chatProvider.mediaList.isNotEmpty ||
                chatProvider.musicList.isNotEmpty
            ? ShowMediaToSendInChat(
                currentUser: currentUser,
                appUser: appUser,
              )
            : Container(
                decoration: BoxDecoration(
                    color: colorWhite,
                    border: Border(
                        top: BorderSide(color: color221.withOpacity(0.3)))),
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 35, top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: !chatProvider.isRecording,
                      child: Expanded(
                        child: ChatTextField(
                          chatController: chatProvider.messageController,
                          ontapSend: () {},
                        ),
                      ),
                    ),
                    Visibility(
                      visible: chatProvider.messageController.text.isEmpty &&
                          !chatProvider.isRecording,
                      child: SpeedDial(
                        closeDialOnPop: true,
                        backgroundColor: Colors.transparent,
                        activeBackgroundColor: colorF03,
                        activeChild: const Icon(
                          Icons.close,
                          size: 26,
                          color: color221,
                        ),
                        buttonSize: Size(40.h, 40.h),
                        overlayColor: Colors.black,
                        overlayOpacity: 0.5,
                        elevation: 0,
                        spacing: 5,
                        childMargin: EdgeInsets.zero,
                        children: [
                          SpeedDialChild(
                            child: Icon(
                              Icons.file_copy_sharp,
                              size: 18.sp,
                            ),
                            onTap: () {
                              chatProvider.getMedia();
                            },
                            label: 'Media',
                          ),
                          SpeedDialChild(
                            child: Icon(
                              Icons.photo_size_select_actual_rounded,
                              size: 18.sp,
                            ),
                            onTap: () {
                              chatProvider.getPhoto();
                            },
                            label: 'Image',
                          ),
                          SpeedDialChild(
                            child: Icon(
                              Icons.video_collection_sharp,
                              size: 18.sp,
                            ),
                            onTap: () {
                              chatProvider.getVideo();
                            },
                            label: 'Video',
                          ),
                          SpeedDialChild(
                            child: Icon(
                              Icons.music_note_outlined,
                              size: 20.sp,
                            ),
                            onTap: () {
                              chatProvider.getMusic();
                            },
                            label: 'Music',
                          ),
                        ],
                        child: SvgPicture.asset(
                          icChatPaperClip,
                          height: 25.h,
                          color: color221,
                        ),
                      ),
                    ),
                    // AnimatedContainer(
                    //   duration: const Duration(milliseconds: 100),
                    //   height: 40.h,
                    //   width: !chatProvider.isRecording
                    //       ? MediaQuery.of(context).size.width * 0
                    //       : MediaQuery.of(context).size.width * .68,
                    //   decoration: BoxDecoration(
                    //       color: colorFF4,
                    //       borderRadius: BorderRadius.circular(30)),
                    //   child: Center(
                    //     child:
                    //         // StreamBuilder<Amplitude?>(
                    //         //   stream: chatProvider.audioRecorder
                    //         //       .onAmplitudeChanged(Duration.zero),
                    //         //   builder: (context, snap) {
                    //         //     // final duration =
                    //         //     //     snap.hasData ? snap.data! : Duration.zero;
                    //         //     if (snap.data!.current == 0.0) {
                    //         //       return widthBox(0);
                    //         //     }
                    //         //     return
                    //         TextWidget(
                    //       text: '0',
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: 16.sp,
                    //       color: colorPrimaryA05,
                    //       //   );
                    //       // },
                    //     ),
                    //   ),
                    // ),
                    Row(
                      children: [
                        Visibility(
                          visible: chatProvider.messageController.text.isEmpty,
                          child: GestureDetector(
                            onLongPress: () {
                              chatProvider.startRecording();
                            },
                            onLongPressEnd: (c) {
                              chatProvider.stopRecording(
                                currentUser: currentUser,
                                appUser: appUser,
                              );

                              // chatProvider.sendVoiceMessage(

                              // );
                            },
                            child: Container(
                              padding: EdgeInsets.all(9.w),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorF03.withOpacity(0.6)),
                              child: const Icon(
                                Icons.mic_none_sharp,
                                color: color221,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          child: Visibility(
                            visible: chatProvider
                                    .messageController.text.isNotEmpty &&
                                !chatProvider.isRecording,
                            child: Row(
                              children: [
                                widthBox(12.w),
                                GestureDetector(
                                  onTap: onTapSentMessage,
                                  child: Image.asset(
                                    imgSendComment,
                                    height: 38.h,
                                    width: 38.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
      },
    );
  }
}

// class VoiceRecordingPlayer extends StatefulWidget {
//   const VoiceRecordingPlayer({
//     Key? key,
//     required this.voiceFile,
//   }) : super(key: key);
//   final File voiceFile;

//   @override
//   State<VoiceRecordingPlayer> createState() => _VoiceRecordingPlayerState();
// }

// class _VoiceRecordingPlayerState extends State<VoiceRecordingPlayer> {
//   late AudioPlayer audioPlayer;
//   bool isPlaying = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;

//   @override
//   void initState() {
//     audioPlayer = AudioPlayer();
//     setAudio();

//     // log(widget.voiceFile.path);
//     audioPlayer.onPlayerStateChanged.listen((event) {
//       if (mounted) {
//         setState(() {
//           isPlaying = event == PlayerState.playing;
//         });
//       }
//     });
//     audioPlayer.onDurationChanged.listen((event) {
//       if (mounted) {
//         setState(() {
//           duration = event;
//         });
//       }
//     });
//     audioPlayer.onPositionChanged.listen((event) {
//       if (mounted) {
//         setState(() {
//           position = event;
//         });
//       }
//     });

//     super.initState();
//   }

//   setAudio() async {
//     await audioPlayer.setSourceDeviceFile(widget.voiceFile.path);
//   }

//   @override
//   void dispose() {
//     audioPlayer.pause();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: ClipRect(
//         clipper: const ClipPad(padding: EdgeInsets.only(top: 30)),
//         child: Container(
//           // height: 100.h,
//           padding: EdgeInsets.only(
//             left: 20.w,
//             right: 20.w,
//             bottom: 20.h,
//           ),
//           decoration: BoxDecoration(
//             color: colorWhite,
//             boxShadow: [
//               BoxShadow(
//                 color: colorPrimaryA05.withOpacity(.36),
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: const Offset(4, 0),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Column(
//                   children: [
//                     SliderTheme(
//                       data: SliderThemeData(
//                         overlayShape: SliderComponentShape.noThumb,
//                       ),
//                       child: Slider(
//                         thumbColor: colorF03,
//                         activeColor: colorF03,
//                         inactiveColor: colorEE5,
//                         min: 0.0,
//                         max: duration.inSeconds.toDouble() + 1.0,
//                         value: position.inSeconds.toDouble() + 0.0,
//                         onChanged: (value) async {
//                           final position = Duration(seconds: value.toInt());
//                           await audioPlayer.seek(position);
//                         },
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         TextWidget(
//                           text: formatTime(position),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             isPlaying
//                                 ? audioPlayer.pause()
//                                 : audioPlayer.resume();
//                           },
//                           child: Icon(isPlaying
//                               ? Icons.pause
//                               : Icons.play_arrow_rounded),
//                         ),
//                         TextWidget(
//                           text: formatTime(duration),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   context.read<ChatProvider>().clearRecorder();
//                 },
//                 icon: const Icon(Icons.close_outlined),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ShowMediaToSendInChat extends StatelessWidget {
  const ShowMediaToSendInChat(
      {Key? key, required this.currentUser, required this.appUser})
      : super(key: key);
  final UserModel currentUser;
  final UserModel appUser;

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<ChatProvider>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        clipper: const ClipPad(padding: EdgeInsets.only(top: 30)),
        child: Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
          ),
          decoration: BoxDecoration(
            color: colorWhite,
            boxShadow: [
              BoxShadow(
                color: colorPrimaryA05.withOpacity(.36),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(4, 0),
              ),
            ],
          ),
          child: SizedBox(
            height: 150.h,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: media.photosList.isNotEmpty
                        ? media.photosList.length
                        : media.videosList.isNotEmpty
                            ? media.videosList.length
                            : media.mediaList.isNotEmpty
                                ? media.mediaList.length
                                : media.musicList.length,
                    itemBuilder: (context, index) {
                      if (media.videosList.isNotEmpty) {
                        VideoPlayerController videoPlayerController;
                        videoPlayerController =
                            VideoPlayerController.file(media.videosList[index])
                              ..initialize().then((value) {});
                        return AspectRatio(
                          aspectRatio: 9 / 13,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: VideoPlayer(
                                  videoPlayerController,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    media.removeVideoFile(
                                        media.videosList[index]);
                                  },
                                  child: SvgPicture.asset(icRemovePost),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      if (media.musicList.isNotEmpty) {
                        return AspectRatio(
                          aspectRatio: 13 / 9,
                          child: Stack(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MusicPlayerWithFile(
                                      musicFile: media.musicList[index])),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    media.removeMusicFile(
                                        media.musicList[index]);
                                  },
                                  child: SvgPicture.asset(icRemovePost),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      if (media.photosList.isNotEmpty) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                media.photosList[index],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  media
                                      .removePhotoFile(media.photosList[index]);
                                },
                                child: SvgPicture.asset(icRemovePost),
                              ),
                            )
                          ],
                        );
                      }
                      if (media.mediaList.isNotEmpty) {
                        var fileName =
                            media.mediaList[index].path.substring(0, 10);

                        return Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .1,
                              width: MediaQuery.of(context).size.width * .6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: colorPrimaryA05,
                              ),
                              child: Center(
                                  child: Row(
                                // mainAxisAlignment:
                                // MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.file_copy,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextWidget(
                                      color: Colors.white,
                                      text: media.mediaList[index].path
                                          .split('/')
                                          .last,
                                    ),
                                  )
                                ],
                              )),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  log(fileName);
                                  media.removeMediaFile(media.mediaList[index]);
                                },
                                child: SvgPicture.asset(icRemovePost),
                              ),
                            )
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                media.photosList.isNotEmpty ||
                        media.videosList.isNotEmpty ||
                        media.mediaList.isNotEmpty
                    ? GestureDetector(
                        onTap: () => media.photosList.isNotEmpty
                            ? media.getPhoto()
                            : media.mediaList.isNotEmpty
                                ? media.getMedia()
                                : media.getVideo(),
                        child: Image.asset(
                          imgAddPost,
                          height: 38.h,
                          width: 38.w,
                        ),
                      )
                    : widthBox(0),
                GestureDetector(
                  onTap: () {
                    media.pickImageAndSentViaMessage(
                      currentUser: currentUser,
                      appUser: appUser,
                      mediaType: media.photosList.isNotEmpty
                          ? 'InChatPic'
                          : media.videosList.isNotEmpty
                              ? 'InChatVideo'
                              : media.mediaList.isNotEmpty
                                  ? 'InChatDoc'
                                  : 'InChatMusic',
                    );

                    Get.defaultDialog(
                      title: 'Sending Attachments',
                      titleStyle: TextStyle(
                        fontSize: 14.sp,
                        color: color221,
                        fontWeight: FontWeight.w500,
                      ),
                      content: Consumer<ChatProvider>(
                        builder: (context, state, b) {
                          if (state.mediaUploadTasks.isNotEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 8.h),
                              child: Column(
                                children: [
                                  LinearProgressIndicator(
                                    value: state.tasksProgress,
                                    minHeight: 10.h,
                                  ),
                                  heightBox(5.h),
                                  TextWidget(
                                    text:
                                        '${(100 * state.tasksProgress).roundToDouble().toInt()}%',
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Done'),
                            );
                          }
                        },
                      ),
                    );
                  },
                  child: Image.asset(
                    imgSendComment,
                    height: 38.h,
                    width: 38.w,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');
}
