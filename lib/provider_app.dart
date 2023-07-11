import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/screens/auth/providers/auth_provider.dart';
import 'package:casarancha/screens/auth/providers/login_provider.dart';
import 'package:casarancha/screens/auth/providers/register_privder.dart';
import 'package:casarancha/screens/auth/providers/setup_profile_provider.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
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
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        ),
        StreamProvider.value(
          value: userDataProvider.currentUser,
          initialData: null,
        ),
        StreamProvider.value(
          value: userDataProvider.posts,
          initialData: null,
        ),
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
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<RegisterProvider>(
            create: (_) => RegisterProvider()),
        ChangeNotifierProvider<SetupProfileProvider>(
            create: (_) => SetupProfileProvider()),
        ChangeNotifierProvider<DatePickerModel>(
            create: (_) => DatePickerModel()),
        ChangeNotifierProvider<DashboardProvider>(
            create: (_) => DashboardProvider())
      ],
      builder: (context, prov) {
        return app;
      },
    );
  }
}
