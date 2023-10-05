import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/screens/auth/providers/auth_provider.dart';
import 'package:casarancha/screens/auth/providers/login_provider.dart';
import 'package:casarancha/screens/auth/providers/phone_provider.dart';
import 'package:casarancha/screens/auth/providers/register_privder.dart';
import 'package:casarancha/screens/auth/providers/setup_profile_provider.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_controller.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/screens/dashboard/provider/download_provider.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_controller.dart';
import 'package:casarancha/screens/home/CreateStory/add_story_controller.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/screens/home/providers/story_provider.dart';
import 'package:casarancha/screens/profile/ProfileScreen/provider/edit_profile_provider.dart';
import 'package:casarancha/screens/profile/ProfileScreen/provider/profile_provider.dart';
import 'package:casarancha/screens/search/search_screen.dart';
import 'package:casarancha/utils/providers/date_picker_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderApp extends StatelessWidget {
  const ProviderApp({Key? key, required this.app}) : super(key: key);
  final Widget app;

  @override
  Widget build(BuildContext context) {
    final userDataProvider = DataProvider();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider(FirebaseAuth.instance)),
        ChangeNotifierProvider<DataProvider>(create: (_) => DataProvider()),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        ),
        StreamProvider.value(
          value: userDataProvider.currentUser,
          initialData: null,
        ),
        // StreamProvider.value(
        //   value: userDataProvider.posts,
        //   initialData: null,
        // ),
        StreamProvider.value(
          value: userDataProvider.stories,
          initialData: null,
        ),
        StreamProvider.value(
          value: userDataProvider.users,
          initialData: null,
        ),
        StreamProvider.value(
          value: userDataProvider.notifications,
          initialData: null,
        ),
        StreamProvider.value(
          value: userDataProvider.chatListUsers,
          initialData: null,
        ),
        StreamProvider.value(
          value: userDataProvider.ghostChatListUsers,
          initialData: null,
        ),
        StreamProvider.value(
          value: userDataProvider.groups,
          initialData: null,
        ),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<RegisterProvider>(
            create: (_) => RegisterProvider()),
        ChangeNotifierProvider<SetupProfileProvider>(
            create: (_) => SetupProfileProvider()),
        ChangeNotifierProvider<DatePickerModel>(
            create: (_) => DatePickerModel()),
        ChangeNotifierProvider<DashboardProvider>(
            create: (_) => DashboardProvider()),
        ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider()),
        ChangeNotifierProvider<StoryProvider>(create: (_) => StoryProvider()),
        ChangeNotifierProvider<PostProvider>(create: (_) => PostProvider()),
        ChangeNotifierProvider<NewGroupProvider>(
            create: (_) => NewGroupProvider()),
        ChangeNotifierProvider<CreatePostMethods>(
            create: (_) => CreatePostMethods()),
        ChangeNotifierProvider<AddStoryProvider>(
            create: (_) => AddStoryProvider()),
        ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
        ChangeNotifierProvider<EditProfileProvider>(
            create: (_) => EditProfileProvider()),
        ChangeNotifierProvider<ChatListController>(
            create: (_) => ChatListController()),
        ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
        ChangeNotifierProvider<PhoneProvider>(create: (_) => PhoneProvider()),
        ChangeNotifierProvider<DownloadProvider>(
            create: (_) => DownloadProvider()),
      ],
      builder: (context, prov) {
        return app;
      },
    );
  }
}
