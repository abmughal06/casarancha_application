import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

import '../../models/message.dart';
import '../../resources/color_resources.dart';
import '../../resources/firebase_cloud_messaging.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../../widgets/common_widgets.dart';
import '../chat/GhostMode/ghost_chat_screen.dart';

// class StoryViewScreen extends StatefulWidget {
//   const StoryViewScreen({Key? key, required this.story}) : super(key: key);

//   final Story story;

//   @override
//   State<StoryViewScreen> createState() => _StoryViewScreenState();
// }

// class _StoryViewScreenState extends State<StoryViewScreen> {
//   late StoryController controller;
//   late TextEditingController commentController;
//   final FocusNode _commentFocus = FocusNode();

//   List<StoryItem> storyItems = [];
//   DateTime twentyFourHoursAgo =
//       DateTime.now().subtract(const Duration(hours: 24));

//   @override
//   void initState() {
//     controller = StoryController();
//     commentController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     commentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String? dateText;
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Expanded(
//               child:  StoryView(
//                   inline: true,
//                   storyItems: [
//                     ...widget.story.mediaDetailsList
//                         .where((element) => DateTime.parse(element.id)
//                             .isAfter(twentyFourHoursAgo))
//                         .map((e) {
//                       dateText = timeago.format(DateTime.parse(e.id));
//                       print("==============  ${e.type}");
//                       return  e.type == "Photo"
//                           ? StoryItem.pageImage(
//                               url: e.link,
//                               controller: controller,
//                             )
//                           : StoryItem.pageVideo(e.link, controller: controller);
//                     })
//                   ],
//                   controller: controller,
//                   // onComplete: () {
//                   //   Get.back();
//                   // },
//                   onVerticalSwipeComplete: (direction) {
//                     if (direction == Direction.down) {
//                       Get.back();
//                     }
//                   }),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
//                   child: profileImgName(
//                     imgUserNet: widget.story.creatorDetails.imageUrl,
//                     isVerifyWithIc: widget.story.creatorDetails.isVerified,
//                     isVerifyWithName: false,
//                     idIsVerified: widget.story.creatorDetails.isVerified,
//                     dpRadius: 17.r,
//                     userName: widget.story.creatorDetails.name,
//                     userNameClr: colorWhite,
//                     userNameFontSize: 12.sp,
//                     userNameFontWeight: FontWeight.w600,
//                     subText: dateText,
//                     subTxtFontSize: 9.sp,
//                     subTxtClr: colorWhite.withOpacity(.5),
//                   ),
//                 ),
//                 Container(),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Focus(
//                       focusNode: _commentFocus,
//                       onFocusChange: (hasFocus) {
//                         hasFocus ? controller.pause() : null;
//                       },
//                       child: TextFormField(
//                         controller: commentController,
//                         onChanged: (val) {
//                           controller.pause();
//                         },
//                         style: TextStyle(
//                           color: color887,
//                           fontSize: 16.sp,
//                           fontFamily: strFontName,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         decoration: InputDecoration(
//                           hintText: strWriteCommentHere,
//                           hintStyle: TextStyle(
//                             color: color887,
//                             fontSize: 14.sp,
//                             fontFamily: strFontName,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           suffixIcon: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10.w),
//                             child: svgImgButton(
//                                 svgIcon: icStoryCmtSend,
//                                 onTap: () async {
//                                   print("comment == " +
//                                       commentController.text.toString());

//                                   FocusScope.of(context).unfocus();
//                                   commentController.text = "";
//                                   controller.play();
//                                   final messageRefForCurrentUser =
//                                       FirebaseFirestore
//                                           .instance
//                                           .collection("users")
//                                           .doc(FirebaseAuth
//                                               .instance.currentUser!.uid)
//                                           .collection('messageList')
//                                           .doc(widget.story.creatorId)
//                                           .collection('messages')
//                                           .doc();

//                                   final messageRefForAppUser = FirebaseFirestore
//                                       .instance
//                                       .collection("users")
//                                       .doc(widget.story.creatorId)
//                                       .collection('messageList')
//                                       .doc(FirebaseAuth
//                                           .instance.currentUser!.uid)
//                                       .collection('messages')
//                                       .doc(
//                                         messageRefForCurrentUser.id,
//                                       );

//                                   var story = widget.story.toMap();

//                                   final Message message = Message(
//                                     id: messageRefForCurrentUser.id,
//                                     sentToId: widget.story.creatorId,
//                                     sentById:
//                                         FirebaseAuth.instance.currentUser!.uid,
//                                     content: story,
//                                     caption: commentController.text,
//                                     type: "story",
//                                     createdAt: DateTime.now().toIso8601String(),
//                                     isSeen: false,
//                                   );
//                                   print(
//                                       "============= ------------------- ------- --= ====== ==== $message");
//                                   final appUserMessage = message.copyWith(
//                                       id: messageRefForAppUser.id);

//                                   messageRefForCurrentUser
//                                       .set(message.toMap())
//                                       .then((value) => print(
//                                           "=========== XXXXXXXXXXXXXXXX ++++++++++ message sent success"));
//                                   messageRefForAppUser
//                                       .set(appUserMessage.toMap());
//                                   var recieverRef = await FirebaseFirestore
//                                       .instance
//                                       .collection("users")
//                                       .doc(widget.story.creatorId)
//                                       .get();

//                                   var recieverFCMToken =
//                                       recieverRef.data()!['fcmToken'];
//                                   print(
//                                       "=========> reciever fcm token = $recieverFCMToken");
//                                   FirebaseMessagingService()
//                                       .sendNotificationToUser(
//                                     creatorDetails: CreatorDetails(
//                                         name: user!.name,
//                                         imageUrl: user!.imageStr,
//                                         isVerified: user!.isVerified),
//                                     // createdAt: message.createdAt,
//                                     // creatorDetails: creatorDetails,
//                                     devRegToken: recieverFCMToken,
//                                     userReqID: widget.story.creatorId,
//                                     title: user!.name,
//                                     msg: "has commented on your story",
//                                   );
//                                 }),
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 12.w, vertical: 12.h),
//                           filled: true,
//                           fillColor: Colors.transparent,
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16.0),
//                               borderSide: BorderSide.none),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30.r),
//                             borderSide: const BorderSide(
//                               color: color887,
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30.r),
//                             borderSide: const BorderSide(
//                               color: color887,
//                               width: 1.0,
//                             ),
//                           ),
//                         ),
//                         textInputAction: TextInputAction.done,
//                         onFieldSubmitted: (val) {
//                           FocusScope.of(context).unfocus();
//                           commentController.text = "";
//                           controller.play();
//                         },
//                         onEditingComplete: () {
//                           FocusScope.of(context).unfocus();
//                           commentController.text = "";
//                           controller.play();
//                         },
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class StoryViewScreen extends StatefulWidget {
  final Story story;

  const StoryViewScreen({
    Key? key,
    required this.story,
  }) : super(key: key);

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  VideoPlayerController? _videoController;
  int _currentIndex = 0;
  DateTime twentyFourHoursAgo =
      DateTime.now().subtract(const Duration(hours: 24));
  List<MediaDetails> storyList = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);

    storyList = widget.story.mediaDetailsList
        .where(
            (element) => DateTime.parse(element.id).isAfter(twentyFourHoursAgo))
        .map((e) => e)
        .toList();
    print(storyList);

    final MediaDetails firstStory = storyList.first;
    _loadStory(story: firstStory, animateToPage: false);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop();
        _animController.reset();
        setState(() {
          if (_currentIndex + 1 < storyList.length) {
            _currentIndex += 1;
            _loadStory(story: storyList[_currentIndex]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            _currentIndex = 0;
            _loadStory(story: storyList[_currentIndex]);
          }
        });
      }
    });
  }

  final FocusNode _commentFocus = FocusNode();
  final textController = TextEditingController();
  ChewieController? controller;

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    _videoController?.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final MediaDetails story = storyList[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: storyList.length,
              onPageChanged: (c) {
                _videoController!.pause();
                _animController.reset();
                _animController.forward();
              },
              itemBuilder: (context, i) {
                final MediaDetails story = storyList[i];
                switch (story.type) {
                  case 'Photo':
                    return GestureDetector(
                      onTapDown: (details) {
                        _onTapDown(details, story);
                      },
                      onLongPressDown: (details) {
                        _animController.stop();
                      },
                      onLongPressEnd: (end) {
                        _animController.forward();
                      },
                      child: CachedNetworkImage(
                        imageUrl: story.link,
                        // fit: BoxFit.cover,
                      ),
                    );
                  case 'Video':
                    // if (_videoController != null &&
                    //     _videoController!.value.isInitialized) {
                    //   return FittedBox(
                    //     fit: BoxFit.cover,
                    //     child: SizedBox(
                    //       width: _videoController!.value.size.width,
                    //       height: _videoController!.value.size.height,
                    //       child: VideoPlayer(_videoController!),
                    //     ),
                    //   );
                    // }
                    controller = ChewieController(
                      videoPlayerController: _videoController!,
                      showControls: false,
                      autoPlay: true,
                      zoomAndPan: true,
                      looping: false,
                    );
                    return GestureDetector(
                      onTapDown: (details) {
                        _onTapDown(details, story);
                      },
                      onLongPress: () {
                        controller!.pause();
                      },
                      onLongPressEnd: (d) {
                        controller!.play();
                      },
                      child: Chewie(
                        controller: controller!,
                      ),
                    );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            Positioned(
              top: 40.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                children: <Widget>[
                  Row(
                    children: storyList
                        .asMap()
                        .map((i, e) {
                          return MapEntry(
                            i,
                            AnimatedBar(
                              animController: _animController,
                              position: i,
                              currentIndex: _currentIndex,
                            ),
                          );
                        })
                        .values
                        .toList(),
                  ),
                  Visibility(
                    visible: widget.story.creatorId !=
                        FirebaseAuth.instance.currentUser!.uid,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 1.5,
                        vertical: 10.0,
                      ),
                      child: UserInfo(
                        user: widget.story.creatorDetails,
                        time: timeago.format(
                            DateTime.parse(storyList[_currentIndex].id)),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.story.creatorId ==
                        FirebaseAuth.instance.currentUser!.uid,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 1.5,
                          vertical: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  var ref1 = FirebaseFirestore.instance
                                      .collection("stories")
                                      .doc(widget.story.creatorId);
                                  var ref = await ref1.get();

                                  List<dynamic> storyRef =
                                      ref.data()!['mediaDetailsList'];

                                  storyRef.removeWhere((element) =>
                                      element['id'] ==
                                      storyList[_currentIndex].id);
                                  await ref1
                                      .update({"mediaDetailsList": storyRef});
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 40.0,
                left: 10.0,
                right: 10.0,
                child: Visibility(
                  visible: widget.story.creatorId !=
                      FirebaseAuth.instance.currentUser!.uid,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Focus(
                      focusNode: _commentFocus,
                      onFocusChange: (hasFocus) {
                        hasFocus
                            ? storyList[_currentIndex].type == "Video"
                                ? controller!.pause()
                                : _animController.stop()
                            : _animController.forward();
                      },
                      child: TextFormField(
                        controller: textController,
                        onChanged: (val) {
                          controller!.pause();
                          _animController.stop();
                        },
                        style: TextStyle(
                          color: color887,
                          fontSize: 16.sp,
                          fontFamily: strFontName,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: strWriteCommentHere,
                          hintStyle: TextStyle(
                            color: color887,
                            fontSize: 14.sp,
                            fontFamily: strFontName,
                            fontWeight: FontWeight.w400,
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: svgImgButton(
                                svgIcon: icStoryCmtSend,
                                onTap: () async {
                                  print("comment == ${textController.text}");

                                  FocusScope.of(context).unfocus();
                                  storyList[_currentIndex].type == "Video"
                                      ? controller!.play()
                                      : null;
                                  _animController.forward();
                                  final messageRefForCurrentUser =
                                      FirebaseFirestore
                                          .instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('messageList')
                                          .doc(widget.story.creatorId)
                                          .collection('messages')
                                          .doc();

                                  final messageRefForAppUser = FirebaseFirestore
                                      .instance
                                      .collection("users")
                                      .doc(widget.story.creatorId)
                                      .collection('messageList')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('messages')
                                      .doc(
                                        messageRefForCurrentUser.id,
                                      );

                                  var storyModel =
                                      storyList[_currentIndex].toMap();

                                  final Message message = Message(
                                    id: messageRefForCurrentUser.id,
                                    sentToId: widget.story.creatorId,
                                    sentById:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    content: storyModel,
                                    caption: textController.text,
                                    type:
                                        "story-${storyList[_currentIndex].type}",
                                    createdAt: DateTime.now().toIso8601String(),
                                    isSeen: false,
                                  );
                                  print(
                                      "============= ------------------- ------- --= ====== ==== $message");
                                  final appUserMessage = message.copyWith(
                                      id: messageRefForAppUser.id);

                                  messageRefForCurrentUser.set(message.toMap());
                                  messageRefForAppUser
                                      .set(appUserMessage.toMap());
                                  var recieverRef = await FirebaseFirestore
                                      .instance
                                      .collection("users")
                                      .doc(widget.story.creatorId)
                                      .get();

                                  var recieverFCMToken =
                                      recieverRef.data()!['fcmToken'];
                                  print(
                                      "=========> reciever fcm token = $recieverFCMToken");
                                  FirebaseMessagingService()
                                      .sendNotificationToUser(
                                    creatorDetails: CreatorDetails(
                                        name: widget.story.creatorDetails.name,
                                        imageUrl: widget
                                            .story.creatorDetails.imageUrl,
                                        isVerified: widget
                                            .story.creatorDetails.isVerified),
                                    // createdAt: message.createdAt,
                                    // creatorDetails: creatorDetails,
                                    devRegToken: recieverFCMToken,
                                    userReqID: widget.story.creatorId,
                                    title: user!.name,
                                    msg: "has commented on your story",
                                  );
                                  textController.clear();
                                }),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 12.h),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: const BorderSide(
                              color: color887,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: const BorderSide(
                              color: color887,
                              width: 1.0,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context).unfocus();
                          // textController.text = "";
                          storyList[_currentIndex].type == "Video"
                              ? controller!.play()
                              : controller!.pause();
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                          // textController.text = "";
                          storyList[_currentIndex].type == "Video"
                              ? controller!.play()
                              : controller!.pause();
                        },
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, MediaDetails story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(story: storyList[_currentIndex]);
          print('1111111111111111111');
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      print('22222222222222');

      setState(() {
        if (_currentIndex + 1 < storyList.length) {
          _currentIndex += 1;
          _loadStory(story: storyList[_currentIndex]);
          print('333333333333');
        } else {
          print('4444444444');

          // Out of bounds - loop story
          Get.back();
          // _currentIndex = 0;
          // _loadStory(story: widget.story.mediaDetailsList[_currentIndex]);
        }
      });
    } else {
      if (story.type == 'Video') {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
          _animController.stop();
        } else {
          _videoController!.play();
          _animController.forward();
        }
      }
    }
  }

  void _onLongPress(LongPressDownDetails details, MediaDetails story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      // setState(() {
      //   if (_currentIndex - 1 >= 0) {
      //     _currentIndex -= 1;
      //     _loadStory(story: storyList[_currentIndex]);
      //     print('1111111111111111111');
      //   }
      // });
      _animController.stop();
    } else if (dx > 2 * screenWidth / 3) {
      // print('22222222222222');

      // setState(() {
      //   if (_currentIndex + 1 < storyList.length) {
      //     _currentIndex += 1;
      //     _loadStory(story: storyList[_currentIndex]);
      //     print('333333333333');
      //   } else {
      //     print('4444444444');

      // Out of bounds - loop story
      Get.back();
      // _currentIndex = 0;
      // _loadStory(story: widget.story.mediaDetailsList[_currentIndex]);
      //   }
      // });
      _animController.stop();
    } else {
      if (story.type == 'Video') {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
          _animController.stop();
        } else {
          _videoController!.play();
          _animController.forward();
        }
      }
    }
  }

  void _loadStory({MediaDetails? story, bool animateToPage = true}) {
    _animController.stop();
    switch (story!.type) {
      case 'Photo':
        _animController.duration = const Duration(
          seconds: 5,
        );

        _animController.forward();

        break;
      case 'Video':
        // _videoController = null;
        // // _videoController!.pause();
        // _videoController?.dispose();
        _videoController = VideoPlayerController.network(story.link)
          ..initialize().then((_) {
            setState(() {});
            if (_videoController!.value.isInitialized) {
              _animController.duration = const Duration(
                seconds: 15,
              );
              // _videoController!.play();
              _animController.forward();
            }
          });
        break;
    }
    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    Key? key,
    required this.animController,
    required this.position,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animController.value,
                            Colors.white,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final CreatorDetails user;
  final String? time;

  const UserInfo({
    Key? key,
    required this.user,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        backgroundColor: Colors.grey[300],
        backgroundImage: CachedNetworkImageProvider(
          user.imageUrl,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          widthBox(5.w),
          Visibility(
            visible: user.isVerified,
            child: SvgPicture.asset(
              icVerifyBadge,
              width: 17.w,
              height: 17.h,
            ),
          )
        ],
      ),
      subtitle: Text(
        time!,
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.close,
          size: 30.0,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}


// class StoryViewScreen extends StatefulWidget {
//   final Story story;

//   const StoryViewScreen({Key? key, required this.story}) : super(key: key);

//   @override
//   State<StoryViewScreen> createState() => _StoryViewScreenState();
// }

// class _StoryViewScreenState extends State<StoryViewScreen> {
//   final controller = StoryController();
//   DateTime twentyFourHoursAgo =
//       DateTime.now().subtract(const Duration(hours: 24));
//   var time = "".obs;
//   final textController = TextEditingController();
//   VideoPlayerController? videoPlayerController;
//   final FocusNode _commentFocus = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       bottom: false,
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
//               child: profileImgName(
//                 imgUserNet: widget.story.creatorDetails.imageUrl,
//                 isVerifyWithIc: widget.story.creatorDetails.isVerified,
//                 isVerifyWithName: false,
//                 idIsVerified: widget.story.creatorDetails.isVerified,
//                 dpRadius: 17.r,
//                 userName: widget.story.creatorDetails.name,
//                 userNameClr: colorWhite,
//                 userNameFontSize: 12.sp,
//                 userNameFontWeight: FontWeight.w600,
//                 subText: time.value,
//                 subTxtFontSize: 9.sp,
//                 subTxtClr: colorWhite.withOpacity(.5),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: StoryView(
//                 indicatorColor: Colors.white,

//                 storyItems: widget.story.mediaDetailsList
//                     .where((element) =>
//                         DateTime.parse(element.id).isAfter(twentyFourHoursAgo))
//                     .map((e) {
//                   time.value = timeago.format(DateTime.parse(e.id));
//                   if (e.type == "Photo") {
//                     controller.pause();
//                     return StoryItem(
//                         Container(
//                           decoration: const BoxDecoration(color: Colors.black),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Align(
//                                 alignment: Alignment.center,
//                                 child: AspectRatio(
//                                   aspectRatio: 2 / 3,
//                                   child: CachedNetworkImage(
//                                     imageUrl: e.link,
//                                     fit: BoxFit.contain,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 15),
//                                 child: Focus(
//                                   focusNode: _commentFocus,
//                                   onFocusChange: (hasFocus) {
//                                     hasFocus ? controller.pause() : null;
//                                   },
//                                   child: TextFormField(
//                                     controller: textController,
//                                     onChanged: (val) {
//                                       controller.pause();
//                                     },
//                                     style: TextStyle(
//                                       color: color887,
//                                       fontSize: 16.sp,
//                                       fontFamily: strFontName,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     decoration: InputDecoration(
//                                       hintText: strWriteCommentHere,
//                                       hintStyle: TextStyle(
//                                         color: color887,
//                                         fontSize: 14.sp,
//                                         fontFamily: strFontName,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                       suffixIcon: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10.w),
//                                         child: svgImgButton(
//                                             svgIcon: icStoryCmtSend,
//                                             onTap: () async {
//                                               print("comment == " +
//                                                   textController.text
//                                                       .toString());

//                                               FocusScope.of(context).unfocus();
//                                               textController.text = "";
//                                               controller.play();
//                                               final messageRefForCurrentUser =
//                                                   FirebaseFirestore.instance
//                                                       .collection("users")
//                                                       .doc(FirebaseAuth.instance
//                                                           .currentUser!.uid)
//                                                       .collection('messageList')
//                                                       .doc(widget
//                                                           .story.creatorId)
//                                                       .collection('messages')
//                                                       .doc();

//                                               final messageRefForAppUser =
//                                                   FirebaseFirestore.instance
//                                                       .collection("users")
//                                                       .doc(widget
//                                                           .story.creatorId)
//                                                       .collection('messageList')
//                                                       .doc(FirebaseAuth.instance
//                                                           .currentUser!.uid)
//                                                       .collection('messages')
//                                                       .doc(
//                                                         messageRefForCurrentUser
//                                                             .id,
//                                                       );

//                                               // var post = postModel.toMap();

//                                               final Message message = Message(
//                                                 id: messageRefForCurrentUser.id,
//                                                 sentToId:
//                                                     widget.story.creatorId,
//                                                 sentById: FirebaseAuth
//                                                     .instance.currentUser!.uid,
//                                                 content: widget.story,
//                                                 caption: textController.text,
//                                                 type: widget.story
//                                                     .mediaDetailsList[0].type,
//                                                 createdAt: DateTime.now()
//                                                     .toIso8601String(),
//                                                 isSeen: false,
//                                               );
//                                               print(
//                                                   "============= ------------------- ------- --= ====== ==== $message");
//                                               final appUserMessage =
//                                                   message.copyWith(
//                                                       id: messageRefForAppUser
//                                                           .id);

//                                               messageRefForCurrentUser
//                                                   .set(message.toMap());
//                                               messageRefForAppUser
//                                                   .set(appUserMessage.toMap());
//                                               var recieverRef =
//                                                   await FirebaseFirestore
//                                                       .instance
//                                                       .collection("users")
//                                                       .doc(widget
//                                                           .story.creatorId)
//                                                       .get();

//                                               var recieverFCMToken = recieverRef
//                                                   .data()!['fcmToken'];
//                                               print(
//                                                   "=========> reciever fcm token = $recieverFCMToken");
//                                               FirebaseMessagingService()
//                                                   .sendNotificationToUser(
//                                                 creatorDetails: CreatorDetails(
//                                                     name: widget.story
//                                                         .creatorDetails.name,
//                                                     imageUrl: widget
//                                                         .story
//                                                         .creatorDetails
//                                                         .imageUrl,
//                                                     isVerified: widget
//                                                         .story
//                                                         .creatorDetails
//                                                         .isVerified),
//                                                 // createdAt: message.createdAt,
//                                                 // creatorDetails: creatorDetails,
//                                                 devRegToken: recieverFCMToken,
//                                                 userReqID:
//                                                     widget.story.creatorId,
//                                                 title: user!.name,
//                                                 msg:
//                                                     "has commented on your story",
//                                               );
//                                             }),
//                                       ),
//                                       contentPadding: EdgeInsets.symmetric(
//                                           horizontal: 12.w, vertical: 12.h),
//                                       filled: true,
//                                       fillColor: Colors.transparent,
//                                       border: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(16.0),
//                                           borderSide: BorderSide.none),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(30.r),
//                                         borderSide: const BorderSide(
//                                           color: color887,
//                                         ),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(30.r),
//                                         borderSide: const BorderSide(
//                                           color: color887,
//                                           width: 1.0,
//                                         ),
//                                       ),
//                                     ),
//                                     textInputAction: TextInputAction.done,
//                                     onFieldSubmitted: (val) {
//                                       FocusScope.of(context).unfocus();
//                                       textController.text = "";
//                                       controller.play();
//                                     },
//                                     onEditingComplete: () {
//                                       FocusScope.of(context).unfocus();
//                                       textController.text = "";
//                                       controller.play();
//                                     },
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         duration: const Duration(milliseconds: 2000));
//                   } else {
//                     videoPlayerController =
//                         VideoPlayerController.network(e.link);
//                     videoPlayerController!
//                         .initialize()
//                         .then((value) => videoPlayerController!.pause());

//                     return StoryItem(
//                         Stack(
//                           children: [
//                             Align(
//                               alignment: Alignment.center,
//                               child: StoryView(
//                                   progressPosition: ProgressPosition.none,
//                                   storyItems: [
//                                     StoryItem.pageVideo(e.link,
//                                         controller: controller)
//                                   ],
//                                   controller: controller),
//                             ),
//                             Positioned(
//                               child: Align(
//                                 alignment: Alignment.bottomCenter,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: TextFormField(
//                                     controller: textController,
//                                     onChanged: (val) {
//                                       controller.pause();
//                                     },
//                                     style: TextStyle(
//                                       color: color887,
//                                       fontSize: 16.sp,
//                                       fontFamily: strFontName,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     decoration: InputDecoration(
//                                       hintText: strWriteCommentHere,
//                                       hintStyle: TextStyle(
//                                         color: color887,
//                                         fontSize: 14.sp,
//                                         fontFamily: strFontName,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                       suffixIcon: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10.w),
//                                         child: svgImgButton(
//                                             svgIcon: icStoryCmtSend,
//                                             onTap: () async {
//                                               print("comment == " +
//                                                   textController.text
//                                                       .toString());

//                                               FocusScope.of(context).unfocus();
//                                               textController.text = "";
//                                               controller.play();
//                                               final messageRefForCurrentUser =
//                                                   FirebaseFirestore.instance
//                                                       .collection("users")
//                                                       .doc(FirebaseAuth.instance
//                                                           .currentUser!.uid)
//                                                       .collection('messageList')
//                                                       .doc(widget
//                                                           .story.creatorId)
//                                                       .collection('messages')
//                                                       .doc();

//                                               final messageRefForAppUser =
//                                                   FirebaseFirestore.instance
//                                                       .collection("users")
//                                                       .doc(widget
//                                                           .story.creatorId)
//                                                       .collection('messageList')
//                                                       .doc(FirebaseAuth.instance
//                                                           .currentUser!.uid)
//                                                       .collection('messages')
//                                                       .doc(
//                                                         messageRefForCurrentUser
//                                                             .id,
//                                                       );

//                                               // var post = postModel.toMap();

//                                               final Message message = Message(
//                                                 id: messageRefForCurrentUser.id,
//                                                 sentToId:
//                                                     widget.story.creatorId,
//                                                 sentById: FirebaseAuth
//                                                     .instance.currentUser!.uid,
//                                                 content: widget.story,
//                                                 caption: textController.text,
//                                                 type: widget.story
//                                                     .mediaDetailsList[0].type,
//                                                 createdAt: DateTime.now()
//                                                     .toIso8601String(),
//                                                 isSeen: false,
//                                               );
//                                               print(
//                                                   "============= ------------------- ------- --= ====== ==== $message");
//                                               final appUserMessage =
//                                                   message.copyWith(
//                                                       id: messageRefForAppUser
//                                                           .id);

//                                               messageRefForCurrentUser
//                                                   .set(message.toMap());
//                                               messageRefForAppUser
//                                                   .set(appUserMessage.toMap());
//                                               var recieverRef =
//                                                   await FirebaseFirestore
//                                                       .instance
//                                                       .collection("users")
//                                                       .doc(widget
//                                                           .story.creatorId)
//                                                       .get();

//                                               var recieverFCMToken = recieverRef
//                                                   .data()!['fcmToken'];
//                                               print(
//                                                   "=========> reciever fcm token = $recieverFCMToken");
//                                               FirebaseMessagingService()
//                                                   .sendNotificationToUser(
//                                                 creatorDetails: CreatorDetails(
//                                                     name: widget.story
//                                                         .creatorDetails.name,
//                                                     imageUrl: widget
//                                                         .story
//                                                         .creatorDetails
//                                                         .imageUrl,
//                                                     isVerified: widget
//                                                         .story
//                                                         .creatorDetails
//                                                         .isVerified),
//                                                 // createdAt: message.createdAt,
//                                                 // creatorDetails: creatorDetails,
//                                                 devRegToken: recieverFCMToken,
//                                                 userReqID:
//                                                     widget.story.creatorId,
//                                                 title: user!.name,
//                                                 msg:
//                                                     "has commented on your story",
//                                               );
//                                             }),
//                                       ),
//                                       contentPadding: EdgeInsets.symmetric(
//                                           horizontal: 12.w, vertical: 12.h),
//                                       filled: true,
//                                       fillColor: Colors.transparent,
//                                       border: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(16.0),
//                                           borderSide: BorderSide.none),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(30.r),
//                                         borderSide: const BorderSide(
//                                           color: color887,
//                                         ),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(30.r),
//                                         borderSide: const BorderSide(
//                                           color: color887,
//                                           width: 1.0,
//                                         ),
//                                       ),
//                                     ),
//                                     textInputAction: TextInputAction.done,
//                                     onFieldSubmitted: (val) {
//                                       FocusScope.of(context).unfocus();
//                                       textController.text = "";
//                                       controller.play();
//                                     },
//                                     onEditingComplete: () {
//                                       FocusScope.of(context).unfocus();
//                                       textController.text = "";
//                                       controller.play();
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                         duration: const Duration(milliseconds: 10000));
//                   }
//                 }).toList(),
//                 controller: controller,
//                 progressPosition: ProgressPosition.top,
//                 // onComplete: () {
//                 //   Get.back();
//                 // },
//               ),
//             ),
//             const SizedBox(height: 12),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Focus(
//                 focusNode: _commentFocus,
//                 onFocusChange: (hasFocus) {
//                   hasFocus ? controller.pause() : null;
//                 },
//                 child: TextFormField(
//                   controller: textController,
//                   onChanged: (val) {
//                     controller.pause();
//                   },
//                   style: TextStyle(
//                     color: color887,
//                     fontSize: 16.sp,
//                     fontFamily: strFontName,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   decoration: InputDecoration(
//                     hintText: strWriteCommentHere,
//                     hintStyle: TextStyle(
//                       color: color887,
//                       fontSize: 14.sp,
//                       fontFamily: strFontName,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     suffixIcon: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10.w),
//                       child: svgImgButton(
//                           svgIcon: icStoryCmtSend,
//                           onTap: () async {
//                             print(
//                                 "comment == " + textController.text.toString());

//                             FocusScope.of(context).unfocus();
//                             textController.text = "";
//                             controller.play();
//                             final messageRefForCurrentUser = FirebaseFirestore
//                                 .instance
//                                 .collection("users")
//                                 .doc(FirebaseAuth.instance.currentUser!.uid)
//                                 .collection('messageList')
//                                 .doc(widget.story.creatorId)
//                                 .collection('messages')
//                                 .doc();

//                             final messageRefForAppUser = FirebaseFirestore
//                                 .instance
//                                 .collection("users")
//                                 .doc(widget.story.creatorId)
//                                 .collection('messageList')
//                                 .doc(FirebaseAuth.instance.currentUser!.uid)
//                                 .collection('messages')
//                                 .doc(
//                                   messageRefForCurrentUser.id,
//                                 );

//                             // var post = postModel.toMap();

//                             final Message message = Message(
//                               id: messageRefForCurrentUser.id,
//                               sentToId: widget.story.creatorId,
//                               sentById: FirebaseAuth.instance.currentUser!.uid,
//                               content: widget.story,
//                               caption: textController.text,
//                               type: widget.story.mediaDetailsList[0].type,
//                               createdAt: DateTime.now().toIso8601String(),
//                               isSeen: false,
//                             );
//                             print(
//                                 "============= ------------------- ------- --= ====== ==== $message");
//                             final appUserMessage =
//                                 message.copyWith(id: messageRefForAppUser.id);

//                             messageRefForCurrentUser.set(message.toMap());
//                             messageRefForAppUser.set(appUserMessage.toMap());
//                             var recieverRef = await FirebaseFirestore.instance
//                                 .collection("users")
//                                 .doc(widget.story.creatorId)
//                                 .get();

//                             var recieverFCMToken =
//                                 recieverRef.data()!['fcmToken'];
//                             print(
//                                 "=========> reciever fcm token = $recieverFCMToken");
//                             FirebaseMessagingService().sendNotificationToUser(
//                               creatorDetails: CreatorDetails(
//                                   name: widget.story.creatorDetails.name,
//                                   imageUrl:
//                                       widget.story.creatorDetails.imageUrl,
//                                   isVerified:
//                                       widget.story.creatorDetails.isVerified),
//                               // createdAt: message.createdAt,
//                               // creatorDetails: creatorDetails,
//                               devRegToken: recieverFCMToken,
//                               userReqID: widget.story.creatorId,
//                               title: user!.name,
//                               msg: "has commented on your story",
//                             );
//                           }),
//                     ),
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//                     filled: true,
//                     fillColor: Colors.transparent,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16.0),
//                         borderSide: BorderSide.none),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.r),
//                       borderSide: const BorderSide(
//                         color: color887,
//                       ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.r),
//                       borderSide: const BorderSide(
//                         color: color887,
//                         width: 1.0,
//                       ),
//                     ),
//                   ),
//                   textInputAction: TextInputAction.done,
//                   onFieldSubmitted: (val) {
//                     FocusScope.of(context).unfocus();
//                     textController.text = "";
//                     controller.play();
//                   },
//                   onEditingComplete: () {
//                     FocusScope.of(context).unfocus();
//                     textController.text = "";
//                     controller.play();
//                   },
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
