import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/auth/setup_profile_details.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_chat_helper.dart';
import 'package:casarancha/screens/dashboard/dashboard_controller.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/PostCard/postCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';

class ProfileScreenController extends SuperController {
  ProfileScreenController({this.isFromDelete = false});
  bool isFromDelete;
  final firebaseAuth = FirebaseAuth.instance;
  final fbfirestore = FirebaseFirestore.instance;
  //Obserables
  var user = UserModel(
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

  var isGhostModeOn = false.obs;

  var isGettingUserData = false.obs;

  var userPosts = <PostModel>[].obs;
  var userStories = <Story>[].obs;

  var isGettingUserPosts = false.obs;
  var isGettingUserStories = false.obs;

  //Getters
  Query<Map<String, dynamic>> get userPostsQuerry {
    return fbfirestore.collection('posts').where(
          'creatorId',
          isEqualTo: user.value.id,
        );
  }

  DocumentReference<Map<String, dynamic>> get userDataQuerry {
    return fbfirestore.collection('users').doc(user.value.id);
  }

  RxList<Map<String, dynamic>> getUserImages = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> userImages() {
    List<Map<String, dynamic>> imagesUrls = [];
    for (var element in userPosts) {
      for (var e in element.mediaData) {
        imagesUrls.addIf(e.type == 'Photo', {"link": e.link, "post": element});
      }
    }
    return imagesUrls;
  }

  RxList<Map<String, dynamic>> getUserQuotes = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> userQuotes() {
    List<Map<String, dynamic>> quotes = [];
    for (var element in userPosts) {
      for (var e in element.mediaData) {
        quotes.addIf(e.type == 'Qoute', {"link": e.link, "post": element});
      }
    }
    return quotes;
  }

  RxList<Map<String, dynamic>> getUserVideos = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> userVideos() {
    List<Map<String, dynamic>> videosUrls = [];
    for (var element in userPosts) {
      for (var e in element.mediaData) {
        videosUrls.addIf(e.type == 'Video', {"link": e.link, "post": element});
      }
    }
    return videosUrls;
  }

  Future updatePostList({PostModel? post}) async {
    if (post != null) {
      userPosts.removeWhere((p0) => p0.id == post.id);
    }
    getUserImages.assignAll(userImages());
    getUserQuotes.assignAll(userQuotes());
    getUserVideos.assignAll(userVideos());
  }

  //Methods
  Future<void> getUser() async {
    isGettingUserData.value = true;
    final userId = firebaseAuth.currentUser?.uid;
    final userRef = fbfirestore.collection('users').doc(userId);
    try {
      final userData = await userRef.get();

      if (userData.exists) {
        user.value = UserModel.fromMap(userData.data() as Map<String, dynamic>);
      } else {
        /*    final userData =
            await Get.to<UserModel>(() => const SetupProfileScreen());
        user.value = userData!; */
      }
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }
    isGettingUserData.value = false;
  }

  void setUserProfile(userModel) {
    user.value = userModel;
    isGettingUserData.value = false;
  }

  Future<void> getUserPosts() async {
    isGettingUserPosts.value = true;
    try {
      List<PostModel> helperList = [];
      final userPostsRef = await userPostsQuerry.get();
      final userRef = await userDataQuerry.get();
      for (var element in userPostsRef.docs) {
        var data = element.data();
        data["creatorDetails"]["isVerified"] = userRef.data()?["isVerified"] ??
            data["creatorDetails"]["isVerified"];
        helperList.add(PostModel.fromMap(data));
      }
      userPosts.assignAll(helperList);
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }
    isGettingUserPosts.value = false;
  }

  Future<void> getUserStories() async {
    isGettingUserStories.value = true;
    try {
      List<Story> helperList = [];
      final userStoriesRef = await fbfirestore
          .collection('stories')
          .where(
            'creatorId',
            isEqualTo: user.value.id,
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

  void toggleGhostMode() {
    Get.find<DashboardController>().currentIndex.value = 0;
    isGhostModeOn.toggle();
  }

  Future<void> logout() async {
    try {
      setUserAgain();
      GhostChatHelper.shared.gMessageCtrl.disposeStream();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }
    Get.back(
      closeOverlays: true,
    );
  }

  void setUserAgain() {
    user = UserModel(
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
  }

  //Overrides
  @override
  void onInit() async {
    if (!isFromDelete) {
      await getUser();
      await Future.wait([
        getUserPosts(),
        getUserStories(),
      ]);
    }
    // fbfirestore.doc(user.value.id).update({
    //   'isOnline': true,
    // });
    super.onInit();
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}
