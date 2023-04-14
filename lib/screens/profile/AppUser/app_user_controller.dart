// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:casarancha/models/user_model.dart';

class AppUserController extends GetxController {
  UserModel? appUser;
  String appUserId;
  String currentUserId;
  AppUserController({
    this.appUser,
    required this.appUserId,
    required this.currentUserId,
  });

  //variables
  final fbfirestore = FirebaseFirestore.instance;

  //Obserables
  var appUserData = UserModel(
    id: '',
    email: '',
    username: '',
    dob: '',
    name: '',
    createdAt: '',
    bio: '',
    imageStr: '',
    isOnline: false,
  ).obs;

  var isGettingUserData = false.obs;

  var userPosts = <PostModel>[].obs;
  var userStories = <Story>[].obs;

  var isGettingUserPosts = false.obs;
  var isGettingUserStories = false.obs;

  var isFollowing = false.obs;
  var isLoading = false.obs;

//Getters

  List<Map<String, dynamic>> get getUserImages {
    List<Map<String, dynamic>> imagesUrls = [];
    for (var post in userPosts) {
      for (var element in post.mediaData) {
        imagesUrls.addIf(
            element.type == 'Photo', {"link": element.link, "post": post});
      }
    }
    return imagesUrls;
  }

  List<Map<String, dynamic>> get getUserQuotes {
    List<Map<String, dynamic>> quotes = [];
    for (var post in userPosts) {
      for (var element in post.mediaData) {
        quotes.addIf(
            element.type == 'Qoute', {"link": element.link, "post": post});
      }
    }
    return quotes;
  }

  List<Map<String, dynamic>> get getUserVideos {
    List<Map<String, dynamic>> videosUrls = [];
    for (var post in userPosts) {
      for (var element in post.mediaData) {
        videosUrls.addIf(
            element.type == 'Video', {"link": element.link, "post": post});
      }
    }
    return videosUrls;
  }

//Methods
  Future<void> getAppUser() async {
    isGettingUserData.value = true;

    if (appUser == null) {
      final userRef = fbfirestore.collection('users').doc(appUserId);
      try {
        final userData = await userRef.get();
        appUserData.value =
            UserModel.fromMap(userData.data() as Map<String, dynamic>);
      } catch (e) {
        GlobalSnackBar.show(message: e.toString());
      }
    } else {
      appUserData.value = appUser!;
    }

    isGettingUserData.value = false;
  }

  Future<void> toggleFollowUser() async {
    isLoading.value = true;
    final currentUserRef = fbfirestore.collection('users').doc(currentUserId);
    final appUserRef = fbfirestore.collection('users').doc(appUserId);
    try {
      if (isFollowing.value) {
        //Unfollow
        await currentUserRef.update(
          {
            'followingsIds': FieldValue.arrayRemove([appUserId])
          },
        );
        await appUserRef.update(
          {
            'followersIds': FieldValue.arrayRemove([currentUserId])
          },
        );
        appUserData.value.followersIds.remove(currentUserId);
        isFollowing.value = false;
      } else {
        //Follow
        await currentUserRef.update(
          {
            'followingsIds': FieldValue.arrayUnion([appUserId])
          },
        );
        await appUserRef.update(
          {
            'followersIds': FieldValue.arrayUnion([currentUserId])
          },
        );
        appUserData.value.followersIds.add(currentUserId);
        Get.find<ProfileScreenController>().user.value.followingsIds.add(
              appUserId,
            );
        isFollowing.value = true;
      }
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }
    isLoading.value = false;
  }

  Future<void> getAppUserPosts() async {
    isGettingUserPosts.value = true;
    try {
      List<PostModel> helperList = [];
      final userPostsRef = await fbfirestore
          .collection('posts')
          .where(
            'creatorId',
            isEqualTo: appUserData.value.id,
          )
          .get();
      for (var element in userPostsRef.docs) {
        helperList.add(PostModel.fromMap(element.data()));
      }
      userPosts.assignAll(helperList);
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }
    isGettingUserPosts.value = false;
  }

  Future<void> getAppUserStories() async {
    isGettingUserStories.value = true;
    try {
      List<Story> helperList = [];
      final userStoriesRef = await fbfirestore
          .collection('stories')
          .where(
            'creatorId',
            isEqualTo: appUserData.value.id,
          )
          .get();
      for (var element in userStoriesRef.docs) {
        helperList.add(Story.fromMap(element.data()));
      }
      userStories.assignAll(helperList);
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }
    isGettingUserStories.value = false;
  }

  //OverRides
  @override
  void onInit() async {
    await getAppUser();
    await Future.wait([
      getAppUserPosts(),
      getAppUserStories(),
    ]);

    print(appUserData.value.followersIds);
    print(currentUserId);

    isFollowing.value = appUserData.value.followersIds.contains(currentUserId);

    print(isFollowing.value);
    super.onInit();
  }
}
