import 'package:casarancha/firebase_options.dart';
import 'package:casarancha/provider_app.dart';
import 'package:casarancha/utils/providers/locale_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'authenticator.dart';
import 'utils/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'Casarancha', options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return StreamBuilder<User?>(
          initialData: null,
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return ProviderApp(
              app: Portal(
                child: Consumer<LocaleProvider>(
                  builder: (context, locale, b) {
                    locale.getLang();
                    return GetMaterialApp(
                      navigatorKey: rootNavigatorKey,
                      localizationsDelegates: const [
                        AppLocalizations.delegate, // Add this line
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      locale: Locale(locale.currentLang ?? 'en'),
                      supportedLocales:
                          locale.allLocales.map((e) => Locale(e)).toList(),
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                        primarySwatch: Colors.red,
                        useMaterial3: false,
                      ),
                      home: const Authenticate(),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
