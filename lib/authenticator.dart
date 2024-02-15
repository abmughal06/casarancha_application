import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/auth/setup_profile_details.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/screens/profile/settings/settings.dart';
import 'package:casarancha/utils/providers/locale_provider.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser == null) {
      return const LoginScreen();
    } else {
      return Consumer<UserModel?>(
        builder: (context, user, child) {
          if (user == null) {
            return Scaffold(
              body: centerLoader(),
            );
          } else if (user.name.isEmpty || user.username.isEmpty) {
            return const SetupProfileScreen();
          } else {
            return const DashBoard();
          }
        },
      );
    }
  }
}

class CheckLocale extends StatelessWidget {
  const CheckLocale({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalizationService.getLocale(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: centerLoader(),
          );
        } else if (snap.data == null) {
          return LannguageSelectionPage(
            locale: snap.data!.countryCode,
          );
        } else {
          return const Authenticate();
        }
      },
    );
  }
}

class LannguageSelectionPage extends StatelessWidget {
  const LannguageSelectionPage({super.key, this.locale});
  final String? locale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: "Select Language"),
      body: ListView.builder(
          itemCount: LocalizationService.supportedLanguages.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                LocalizationService.setLocale(LocalizationService
                    .supportedLanguages[index]
                    .toLowerCase());
                HotRestartController.performHotRestart(context);
              },
              leading: SizedBox(
                height: 30.h,
                width: 50.w,
                child: SvgPicture.network(
                    LocalizationService.supportedLanguagesFlags[index]),
              ),
              title: TextWidget(
                  text: LocalizationService.supportedLanguagesName[index]),
              trailing: TextWidget(
                  text: locale ??
                      LocalizationService.supportedLanguages[index]
                          .toUpperCase()),
            );
          }),
    );
  }
}
