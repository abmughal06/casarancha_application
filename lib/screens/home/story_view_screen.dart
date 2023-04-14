import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/widgets/home_page_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:story_view/story_view.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

import '../../resources/color_resources.dart';

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
//     final dateText = timeago.format(DateTime.parse(widget.story.createdAt));
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Expanded(
//               child: StoryView(
//                   storyItems: [
//                     ...widget.story.mediaDetailsList.map(
//                       (e) => StoryItem.pageImage(
//                         url: e.link,
//                         controller: controller,
//                       ),
//                     )
//                   ],
//                   controller: controller,
//                   onComplete: () {
//                     Get.back();
//                   },
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
//                 // Align(
//                 //   alignment: Alignment.bottomCenter,
//                 //   child: Padding(
//                 //     padding: const EdgeInsets.all(10.0),
//                 //     child: Focus(
//                 //       focusNode: _commentFocus,
//                 //       onFocusChange: (hasFocus) {
//                 //         hasFocus ? controller.pause() : null;
//                 //       },
//                 //       child: TextFormField(
//                 //         controller: commentController,
//                 //         onChanged: (val) {
//                 //           controller.pause();
//                 //         },
//                 //         style: TextStyle(
//                 //           color: color887,
//                 //           fontSize: 16.sp,
//                 //           fontFamily: strFontName,
//                 //           fontWeight: FontWeight.w500,
//                 //         ),
//                 //         decoration: InputDecoration(
//                 //           hintText: strWriteCommentHere,
//                 //           hintStyle: TextStyle(
//                 //             color: color887,
//                 //             fontSize: 14.sp,
//                 //             fontFamily: strFontName,
//                 //             fontWeight: FontWeight.w400,
//                 //           ),
//                 //           suffixIcon: Padding(
//                 //             padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 //             child: svgImgButton(
//                 //                 svgIcon: icStoryCmtSend,
//                 //                 onTap: () {
//                 //                   if (kDebugMode) {
//                 //                     print("comment == " +
//                 //                         commentController.text.toString());
//                 //                   }
//                 //                   FocusScope.of(context).unfocus();
//                 //                   commentController.text = "";
//                 //                   controller.play();
//                 //                 }),
//                 //           ),
//                 //           contentPadding: EdgeInsets.symmetric(
//                 //               horizontal: 12.w, vertical: 12.h),
//                 //           filled: true,
//                 //           fillColor: Colors.transparent,
//                 //           border: OutlineInputBorder(
//                 //               borderRadius: BorderRadius.circular(16.0),
//                 //               borderSide: BorderSide.none),
//                 //           focusedBorder: OutlineInputBorder(
//                 //             borderRadius: BorderRadius.circular(30.r),
//                 //             borderSide: const BorderSide(
//                 //               color: color887,
//                 //             ),
//                 //           ),
//                 //           enabledBorder: OutlineInputBorder(
//                 //             borderRadius: BorderRadius.circular(30.r),
//                 //             borderSide: const BorderSide(
//                 //               color: color887,
//                 //               width: 1.0,
//                 //             ),
//                 //           ),
//                 //         ),
//                 //         textInputAction: TextInputAction.done,
//                 //         onFieldSubmitted: (val) {
//                 //           FocusScope.of(context).unfocus();
//                 //           commentController.text = "";
//                 //           controller.play();
//                 //         },
//                 //         onEditingComplete: () {
//                 //           FocusScope.of(context).unfocus();
//                 //           commentController.text = "";
//                 //           controller.play();
//                 //         },
//                 //       ),
//                 //     ),
//                 //   ),
//                 // )
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
  _StoryViewScreenState createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  VideoPlayerController? _videoController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);

    final MediaDetails firstStory = widget.story.mediaDetailsList.first;
    _loadStory(story: firstStory, animateToPage: false);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop();
        _animController.reset();
        setState(() {
          if (_currentIndex + 1 < widget.story.mediaDetailsList.length) {
            _currentIndex += 1;
            _loadStory(story: widget.story.mediaDetailsList[_currentIndex]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            _currentIndex = 0;
            _loadStory(story: widget.story.mediaDetailsList[_currentIndex]);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaDetails story = widget.story.mediaDetailsList[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, story),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.story.mediaDetailsList.length,
              itemBuilder: (context, i) {
                final MediaDetails story = widget.story.mediaDetailsList[i];
                switch (story.type) {
                  case 'Photo':
                    return CachedNetworkImage(
                      imageUrl: story.link,
                      // fit: BoxFit.cover,
                    );
                  case 'Video':
                    if (_videoController != null &&
                        _videoController!.value.isInitialized) {
                      return FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoController!.value.size.width,
                          height: _videoController!.value.size.height,
                          child: VideoPlayer(_videoController!),
                        ),
                      );
                    }
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
                    children: widget.story.mediaDetailsList
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.5,
                      vertical: 10.0,
                    ),
                    child: UserInfo(user: widget.story.creatorDetails),
                  ),
                ],
              ),
            ),
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
          _loadStory(story: widget.story.mediaDetailsList[_currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.story.mediaDetailsList.length) {
          _currentIndex += 1;
          _loadStory(story: widget.story.mediaDetailsList[_currentIndex]);
        } else {
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

  void _loadStory({MediaDetails? story, bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();
    switch (story!.type) {
      case 'Photo':
        _animController.duration = const Duration(
          seconds: 10,
        );
        _animController.forward();
        break;
      case 'Video':
        _videoController = null;
        _videoController?.dispose();
        _videoController = VideoPlayerController.network(story.link)
          ..initialize().then((_) {
            setState(() {});
            if (_videoController!.value.isInitialized) {
              _animController.duration = _videoController!.value.duration;
              _videoController!.play();
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

  const UserInfo({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.grey[300],
          backgroundImage: CachedNetworkImageProvider(
            user.imageUrl,
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
