import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/widgets/home_screen_widgets/story_views_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../resources/color_resources.dart';
import '../../widgets/common_widgets.dart';

bool isDateAfter24Hour(DateTime date) {
  DateTime twentyFourHoursAgo =
      DateTime.now().subtract(const Duration(hours: 24));
  if (date.isAfter(twentyFourHoursAgo)) {
    return true;
  }
  return false;
}

class MyStoryViewScreen extends StatefulWidget {
  final Story stories;

  const MyStoryViewScreen({super.key, required this.stories});

  @override
  State<MyStoryViewScreen> createState() => _MyStoryViewScreenState();
}

class _MyStoryViewScreenState extends State<MyStoryViewScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;

  List storyItems = [];
  VideoPlayerController? _videoController;

  bool isVideoPlaying = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);

    _videoController = VideoPlayerController.networkUrl(Uri.parse(''));
    storyItems = widget.stories.mediaDetailsList
        .where((element) => isDateAfter24Hour(DateTime.parse(element.id)))
        .toList();

    final firstStory = storyItems.first;
    _loadStory(story: firstStory, animateToPage: false);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop();
        _animController.reset();
        setState(() {
          if (_currentIndex + 1 < storyItems.length) {
            _currentIndex += 1;
            _loadStory(story: storyItems[_currentIndex]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            Get.back();
            _currentIndex = 0;
            _loadStory(story: storyItems[_currentIndex]);
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
    // final s1 = storyItems= storyItems

    final story = storyItems[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTapDown: (details) => _onTapDown(details, story),
          child: Stack(
            children: <Widget>[
              PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: storyItems.length,
                itemBuilder: (context, i) {
                  // final MediaDetails story = story;
                  switch (story.type) {
                    case 'Photo':
                      return CachedNetworkImage(
                        imageUrl: story.link,
                        fit: BoxFit.cover,
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
                  return const SizedBox.shrink();
                },
              ),
              Positioned(
                top: 10.0,
                left: 10.0,
                right: 10.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: storyItems
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 1.5,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        pauseAndPlayStory(story);
                        Get.bottomSheet(TapRegion(
                          onTapOutside: (event) => pauseAndPlayStory(story),
                          child: storyViews(
                              viwersIds: storyItems[_currentIndex].storyViews!),
                        ));
                      },
                      child: SizedBox(
                        width: 100.w,
                        child: Row(
                          children: [
                            widthBox(10.w),
                            const Icon(
                              Icons.visibility,
                              color: color887,
                            ),
                            widthBox(5.w),
                            TextWidget(
                              text: storyItems[_currentIndex]
                                  .storyViews!
                                  .length
                                  .toString(),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: color887,
                            )
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (storyItems[_currentIndex].id ==
                            storyItems.last.id) {
                          Get.back();

                          var ref1 = FirebaseFirestore.instance
                              .collection("stories")
                              .doc(widget.stories.id);
                          var ref = await ref1.get();

                          List<dynamic> storyRef =
                              ref.data()!['mediaDetailsList'];

                          storyRef.removeWhere((element) =>
                              element['id'] == storyItems[_currentIndex].id);

                          await ref1.update({"mediaDetailsList": storyRef});
                        } else {
                          var ref1 = FirebaseFirestore.instance
                              .collection("stories")
                              .doc(widget.stories.id);
                          var ref = await ref1.get();

                          List<dynamic> storyRef =
                              ref.data()!['mediaDetailsList'];

                          storyRef.removeWhere((element) =>
                              element['id'] == storyItems[_currentIndex].id);
                          await ref1.update({"mediaDetailsList": storyRef});
                          pauseAndPlayStory(story);
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pauseAndPlayStory(MediaDetails story) {
    if (_animController.isAnimating) {
      if (story.type == 'Video') {
        // if (_videoController != null) {
        //   _videoController!.pause();
        // _animController.stop();
        // }

        _animController.stop();
        _videoController!.pause();
      } else {
        _animController.stop();
      }
    } else {
      if (story.type == 'Video') {
        if (_videoController != null) {
          _videoController!.play();
          _animController.forward();
        }
        // isVideoPlaying = true;
        // _animController.forward();
      } else {
        _animController.forward();
      }
    }
    setState(() {});
  }

  void _onTapDown(TapDownDetails details, MediaDetails story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(story: storyItems[_currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < storyItems.length) {
          _currentIndex += 1;
          _loadStory(story: storyItems[_currentIndex]);
        } else {
          // Out of bounds - loop story
          // You can also Navigator.of(context).pop() here
          Get.back();
          _currentIndex = 0;
          _loadStory(story: storyItems[_currentIndex]);
        }
      });
    } else {
      if (story.type == 'Video') {
        if (_videoController != null) {
          _videoController!.pause();
          _animController.stop();
        } else if (_videoController != null) {
          _videoController!.play();
          _animController.forward();
        }
      }
    }
  }

  void _loadStory({required MediaDetails story, bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();
    switch (story.type) {
      case 'Photo':
        _animController.duration = const Duration(seconds: 10);
        _animController.forward();
        break;
      case 'Video':
        _videoController?.dispose(); // Dispose the previous controller

        _videoController =
            VideoPlayerController.networkUrl(Uri.parse(story.link))
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
    super.key,
    required this.animController,
    required this.position,
    required this.currentIndex,
  });

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
