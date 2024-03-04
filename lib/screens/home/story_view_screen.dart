import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../models/ghost_message_details.dart';
import '../../models/message.dart';
import '../../models/message_details.dart';
import '../../models/post_creator_details.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/firebase_cloud_messaging.dart';
import '../../widgets/home_page_widgets.dart';
import '../../widgets/home_screen_widgets/story_textt_field.dart';

bool isDateAfter24Hour(DateTime date) {
  DateTime twentyFourHoursAgo =
      DateTime.now().subtract(const Duration(hours: 24));
  if (date.isAfter(twentyFourHoursAgo)) {
    return true;
  }
  return false;
}

class StoryViewScreen extends StatefulWidget {
  final Story stories;

  const StoryViewScreen({super.key, required this.stories});

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  VideoPlayerController? _videoController;

  late TextEditingController commentController;
  final FocusNode _commentFocus = FocusNode();
  List<MediaDetails> storyItems = [];

  int _currentIndex = 0;
  bool isVideoPlaying = true;
  bool isVideoInitialized = false;

  var unreadMessageCount = 0;

  countStoryViews({required List<MediaDetails> mediaList}) async {
    var storyViewsList = mediaList[_currentIndex].storyViews;

    if (!storyViewsList!.contains(FirebaseAuth.instance.currentUser!.uid)) {
      storyViewsList.add(FirebaseAuth.instance.currentUser!.uid);
      mediaList[_currentIndex].storyViews = storyViewsList;

      var ref = FirebaseFirestore.instance
          .collection("stories")
          .doc(widget.stories.id);

      var media = mediaList.map((e) => e.toMap()).toList();
      ref.update({'mediaDetailsList': media});
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);
    commentController = TextEditingController();

    storyItems = widget.stories.mediaDetailsList
        .where((element) => isDateAfter24Hour(DateTime.parse(element.id)))
        .toList();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(''));

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
    commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final s1 = widget.stories;

    final story = storyItems[_currentIndex];
    final ghost = Provider.of<DashboardProvider>(context);

    final currentUser = context.watch<UserModel>();
    final cmntMsg = appText(context).strCommentStory;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTapDown: (details) => _onTapDown(details, story),
          onVerticalDragStart: (details) => Get.back(),
          onLongPress: () {
            _animController.stop();
            if (story.type == 'Video') {
              _videoController!.pause();
            }
            setState(() {});
          },
          onLongPressEnd: (b) {
            _animController.forward();
            if (story.type == 'Video') {
              _videoController!.play();
            }
            setState(() {});
          },
          child: Stack(
            children: <Widget>[
              PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: storyItems.length,
                itemBuilder: (context, i) {
                  final MediaDetails story = storyItems[i];
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
                top: 40.0,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 1.5,
                        vertical: 10.0,
                      ),
                      child: profileImgName(
                        imgUserNet: widget.stories.creatorDetails.imageUrl,
                        isVerifyWithName: false,
                        idIsVerified: widget.stories.creatorDetails.isVerified,
                        dpRadius: 17.r,
                        userName: widget.stories.creatorDetails.name,
                        userNameClr: colorWhite,
                        userNameFontSize: 12.sp,
                        userNameFontWeight: FontWeight.w600,
                        subText: convertDateIntoTime(story.id),
                        subTxtFontSize: 9.sp,
                        subTxtClr: colorWhite.withOpacity(.5),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _commentFocus.hasFocus,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _commentFocus.unfocus();
                    });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !_commentFocus.hasFocus,
                child: Container(),
              ),
              StoryTextField(
                commentFocus: _commentFocus,
                onfocusChange: (hasFocus) {
                  pauseAndPlayStory(story);
                },
                textEditingController: commentController,
                onchange: (c) {},
                onFieldSubmitted: (val) {
                  FocusScope.of(context).unfocus();
                  commentController.text = "";
                  pauseAndPlayStory(story);
                },
                onEditCompleted: () {
                  FocusScope.of(context).unfocus();
                  commentController.text = "";
                  pauseAndPlayStory(story);
                },
                ontapSend: () async {
                  sentComment(
                    checkGhostMode: ghost.checkGhostMode,
                    currentUser: currentUser,
                    cmntMsg: cmntMsg,
                  );
                  _commentFocus.unfocus();
                  commentController.text = "";
                  pauseAndPlayStory(storyItems[_currentIndex]);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  sentComment({checkGhostMode, currentUser, cmntMsg}) async {
    if (checkGhostMode) {
      final GhostMessageDetails messageDetails = GhostMessageDetails(
        id: getConversationDocId(currentUser.id, widget.stories.creatorId),
        lastMessage: "Story",
        unreadMessageCount: 0,
        searchCharacters: [
          ...widget.stories.creatorDetails.name.toLowerCase().split('')
        ],
        creatorDetails: CreatorDetails(
          name: currentUser.name,
          imageUrl: currentUser.imageStr,
          isVerified: currentUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
        firstMessage: currentUser.id,
      );

      await FirebaseFirestore.instance
          .collection('ghost_messages')
          .doc(getConversationDocId(currentUser.id, widget.stories.creatorId))
          .set(messageDetails.toMap());
    } else {
      final MessageDetails messageDetails = MessageDetails(
        id: getConversationDocId(currentUser.id, widget.stories.creatorId),
        creatorId: '',
        lastMessage: "Story",
        unreadMessageCount: unreadMessageCount + 1,
        searchCharacters: [...currentUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: currentUser.name,
          imageUrl: currentUser.imageStr,
          isVerified: currentUser.isVerified,
        ),
        createdAt: DateTime.now().toUtc().toString(),
      );

      await FirebaseFirestore.instance
          .collection('messages')
          .doc(getConversationDocId(currentUser.id, widget.stories.creatorId))
          .set(messageDetails.toMap());
    }
    final chatRef = FirebaseFirestore.instance
        .collection(checkGhostMode ? 'ghost_messages' : 'messages')
        .doc(getConversationDocId(currentUser.id, widget.stories.creatorId))
        .collection('chats')
        .doc();

    var story = storyItems.toList();
    var mediaDetail = story[_currentIndex].toMap();

    final Message message = Message(
      id: chatRef.id,
      isReply: false,
      sentToId: widget.stories.creatorId,
      sentById: currentUser.id,
      content: mediaDetail,
      caption: commentController.text,
      type: "story-${story[_currentIndex].type}",
      createdAt: DateTime.now().toUtc().toString(),
      isSeen: false,
    );

    chatRef.set(message.toMap());
    var recieverRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.stories.creatorId)
        .get();

    var recieverFCMToken = recieverRef.data()!['fcmToken'];

    FirebaseMessagingService().sendNotificationToUser(
      appUserId: recieverRef.id,
      content: storyItems[_currentIndex].type == 'Photo'
          ? storyItems[_currentIndex].link
          : '',
      groupId: null,
      notificationType: "msg",
      isMessage: true,
      ghostmode: checkGhostMode,
      devRegToken: recieverFCMToken,
      msg: cmntMsg,
    );
  }

  pauseAndPlayStory(MediaDetails story) {
    if (_commentFocus.hasFocus) {
      if (story.type == 'Video') {
        if (_videoController != null && _videoController!.value.isInitialized) {
          _videoController!.pause();
          _animController.stop();
        }
        // isVideoPlaying = false;
        // _animController.stop();
      } else {
        _animController.stop();
      }
    } else {
      if (story.type == 'Video') {
        if (_videoController != null && _videoController!.value.isInitialized) {
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
    if (!_commentFocus.hasFocus) {
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
          if (_videoController != null && _videoController!.value.isPlaying) {
            _videoController!.pause();
            _animController.stop();
          } else if (_videoController != null) {
            _videoController!.play();
            _animController.forward();
          }
          // if (isVideoPlaying) {
          //   _animController.forward();
          // } else {
          //   _animController.stop();
          // }
        }
      }
    }
  }

  void _loadStory({required MediaDetails story, bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();
    countStoryViews(mediaList: storyItems);
    switch (story.type) {
      case 'Photo':
        _animController.duration = const Duration(seconds: 10);
        _animController.forward();
        break;
      case 'Video':
        // if (isVideoPlaying) {
        //   isVideoPlaying = true;
        //   _animController.duration = const Duration(milliseconds: 20000);
        //   _animController.forward();
        // }
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
