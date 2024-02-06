import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:casarancha/resources/firebase_cloud_messaging.dart';
import 'package:casarancha/screens/auth/setup_profile_details.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path/path.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../resources/color_resources.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/snackbar.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/text_widget.dart';
import '../phone_otp_screen.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  final message = FirebaseMessagingService();
  AuthenticationProvider(this.firebaseAuth);

  Stream<User?> get authState => firebaseAuth.idTokenChanges();

  bool isSigningIn = false;

  Future<void> signUp(
      {String? email, String? password, String? confirmPassword}) async {
    if (checkValidDataRegister(
        email: email, password: password, confirmPassword: confirmPassword)) {
      try {
        isSigningIn = true;
        notifyListeners();
        await firebaseAuth
            .createUserWithEmailAndPassword(email: email!, password: password!)
            .whenComplete(() => saveTokenAndNavigateToNext());
      } on FirebaseAuthException catch (e) {
        GlobalSnackBar.show(message: appText(context).strUnknownError);
        printLog(e);
      } finally {
        isSigningIn = false;
        notifyListeners();
      }
    }
  }

  void saveTokenAndNavigateToNext() async {
    var ref = FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid);
    var data = await ref.get();
    if (data.exists) {
      var token = await message.getFirebaseToken();
      await ref.set({"fcmToken": token}, SetOptions(merge: true));

      if (!data.data()!.containsKey("ghostName")) {
        ref.set({
          "ghostName": "Ghost---- ${AppUtils.instance.generateRandomNumber()}"
        }, SetOptions(merge: true));
      }
      if (!data.data()!.containsKey("blockIds")) {
        ref.set({
          "blockIds": FieldValue.arrayUnion([]),
        }, SetOptions(merge: true));
      }
      if (!data.data()!.containsKey('isWorkVerified') ||
          !data.data()!.containsKey('isEducationVerified')) {
        ref.set({
          'isWorkVerified': false,
          'isEducationVerified': false,
        }, SetOptions(merge: true));
      }
      Get.offAll(() => const DashBoard());
    } else {
      Get.offAll(() => const SetupProfileScreen());
    }
  }

  Future<void> signIn(
      {String? email, String? password, required BuildContext context}) async {
    if (checkValidDataLogin(
        email: email, password: password, context: context)) {
      try {
        isSigningIn = true;
        notifyListeners();

        await firebaseAuth
            .signInWithEmailAndPassword(email: email!, password: password!)
            .whenComplete(() => saveTokenAndNavigateToNext());
      } on FirebaseAuthException catch (e) {
        // ignore: use_build_context_synchronously
        GlobalSnackBar.show(message: appText(context).strUnknownError);
        printLog(e);
      } finally {
        isSigningIn = false;
        notifyListeners();
      }
    }
  }

  Future<void> verifyPhoneNumber(number) async {
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      barrierDismissible: false,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator.adaptive(),
          widthBox(15.w),
          TextWidget(
            text: appText(context).verifyingNumber,
            color: color55F,
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) {
          dev.log('complete $credential');
          saveTokenAndNavigateToNext();
        },
        verificationFailed: (FirebaseAuthException e) {
          dev.log('failed $e');
          Get.back();
          GlobalSnackBar.show(message: appText(context).strPhoneVerifyFailed);
        },
        codeSent: (String verificationId, int? resendToken) {
          dev.log('code sent');
          Get.back();
          Get.to(
            () => PhoneOTPScreen(
              verificationId: verificationId,
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          dev.log(verificationId);
        },
      );
    } on FirebaseAuthException catch (e) {
      GlobalSnackBar.show(message: 'Please enter ${e.message}');
      Get.back();
    } catch (e) {
      GlobalSnackBar.show(message: 'Phone login cancelled');
      Get.back();
    } finally {
      isSigningIn = false;
      notifyListeners();
    }
  }

  Future<void> checkOtpVerification(smsCode, verifyId) async {
    isSigningIn = true;
    notifyListeners();
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      barrierDismissible: false,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator.adaptive(),
          widthBox(15.w),
          TextWidget(
            text: appText(context).verifyingOTP,
            color: color55F,
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verifyId, smsCode: smsCode);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      saveTokenAndNavigateToNext();
    } on FirebaseAuthException catch (e) {
      Get.back();
      GlobalSnackBar.show(message: 'Please enter ${e.message}');
    } catch (e) {
      Get.back();
      GlobalSnackBar.show(message: 'Phone login cancelled');
    } finally {
      isSigningIn = false;
      notifyListeners();
    }
  }

  Future<void> callGoogleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
    if (signInAccount != null) {
      try {
        isSigningIn = true;
        notifyListeners();

        GoogleSignInAuthentication googleSignInAuthentication =
            await signInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        saveTokenAndNavigateToNext();
      } on FirebaseAuthException catch (e) {
        isSigningIn = false;
        notifyListeners();

        GlobalSnackBar.show(message: 'Please enter ${e.message}');
      } catch (e) {
        isSigningIn = false;
        notifyListeners();

        GlobalSnackBar.show(message: 'Google login cancelled');
      } finally {
        isSigningIn = false;
        notifyListeners();
      }
    }
  }

  Future<void> updateEmail(
      {required String oldEmail,
      required String password,
      required String newEmail}) async {
    try {
      isSigningIn = true;
      notifyListeners();
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: oldEmail.trim(), password: password.trim());
      if (userCredential.user != null) {
        await userCredential.user?.updateEmail(newEmail.trim());
      }
    } on FirebaseAuthException catch (e) {
      isSigningIn = false;
      notifyListeners();

      GlobalSnackBar.show(message: 'Please enter ${e.message}');
    } catch (e) {
      isSigningIn = false;
      notifyListeners();
      print(e);
    } finally {
      isSigningIn = false;
      notifyListeners();
    }
  }

  Future<void> callAppleSignIn() async {
    String generateNonce([int length = 32]) {
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(
          length, (_) => charset[random.nextInt(charset.length)]).join();
    }

    /// Returns the sha256 hash of [input] in hex notation.
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    try {
      isSigningIn = true;
      notifyListeners();

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      if (appleCredential.identityToken != null) {
        Map<String, dynamic> userInfo =
            JwtDecoder.decode(appleCredential.identityToken!);
        dev.log("$userInfo");
      }
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      saveTokenAndNavigateToNext();

      dev.log(appleCredential.givenName ?? "");
      dev.log(appleCredential.familyName ?? "");
      if (appleCredential.givenName != null &&
          appleCredential.familyName != null) {
        await userCredential.user?.updateDisplayName(
            "${appleCredential.givenName} ${appleCredential.familyName}");
      }
    } on FirebaseAuthException catch (e) {
      isSigningIn = false;
      notifyListeners();

      GlobalSnackBar.show(message: 'Please enter ${e.message}');
    } catch (e) {
      isSigningIn = false;
      notifyListeners();

      GlobalSnackBar.show(message: 'Apple login cancelled');
    } finally {
      isSigningIn = false;
      notifyListeners();
    }
  }

  bool checkValidDataLogin(
      {String? email, String? password, required BuildContext context}) {
    if (email!.isEmpty) {
      GlobalSnackBar.show(message: appText(context).strErrorEmail);
      return false;
    } else if (!EmailValidator.validate(email)) {
      GlobalSnackBar.show(message: appText(context).strErrorValidEmail);
      return false;
    } else if (password!.isEmpty) {
      GlobalSnackBar.show(message: appText(context).strErrorPassword);
      return false;
    }
    return true;
  }

  bool checkValidDataRegister(
      {String? email, String? password, String? confirmPassword}) {
    if (email!.isEmpty) {
      GlobalSnackBar.show(message: appText(context).strErrorEmail);
      return false;
    } else if (!EmailValidator.validate(email.trim())) {
      GlobalSnackBar.show(message: appText(context).strErrorValidEmail);
      return false;
    } else if (password!.isEmpty) {
      GlobalSnackBar.show(message: appText(context).strErrorPassword);
      return false;
    } else if (password.length < AppConstant.passwordMinText) {
      GlobalSnackBar.show(message: appText(context).strErrorMinPsdReq);
      return false;
    } else if (confirmPassword!.isEmpty) {
      GlobalSnackBar.show(message: appText(context).strErrorConfirmPassword);
      return false;
    } else if (password != confirmPassword) {
      GlobalSnackBar.show(message: appText(context).strErrorSamePassword);
      return false;
    }
    return true;
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> linkPhoneWithEmailAccount(
      {required String email, required String password}) async {
    try {
      isSigningIn = true;
      notifyListeners();
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);

      if (userCredential != null) {
        GlobalSnackBar.show(message: "Account Linked Successfully");
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "email": email,
        });
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          GlobalSnackBar.show(
              message: "The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          GlobalSnackBar.show(
              message: "The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          GlobalSnackBar.show(
              message:
                  "The account corresponding to the credential already exists, "
                  "or is already linked to a Firebase User.");
          break;
        default:
        // GlobalSnackBar.show(message: "Unknown error.");
      }
    } finally {
      isSigningIn = false;
      notifyListeners();
    }
  }
}

// Future<void> callTwitterSignIn() async {
  //   try {
  //     isSigningIn = true;
  //     notifyListeners();

  //     TwitterLogin login = TwitterLogin(
  //       apiKey: "IsOL30I1dqNnJ81lPuHxTKTYF",
  //       apiSecretKey: "cdCKCY75t8Okzwf2ENlOPzvnBMrnins8JtDTE1kp8cLHRuVqfn",
  //       redirectURI: "https://casa-rancha.firebaseapp.com/__/auth/handler",
  //     );
  //     AuthResult authResult = await login.loginV2();
  //     if (authResult.authToken != null && authResult.authTokenSecret != null) {
  //       AuthCredential credential = TwitterAuthProvider.credential(
  //           accessToken: authResult.authToken!,
  //           secret: authResult.authTokenSecret!);
  //       FirebaseAuth.instance.signInWithCredential(credential);
  //       saveTokenAndNavigateToNext();
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     isSigningIn = false;
  //     notifyListeners();

  //     GlobalSnackBar.show(message: 'Please enter ${e.message}');
  //   } finally {
  //     isSigningIn = false;
  //     notifyListeners();
  //   }
  // }

  //=======================


  // Future<void> callFaceBookSignIn() async {
  //   try {
  //     isSigningIn = true;
  //     notifyListeners();

  //     LoginResult loginResult = await FacebookAuth.instance
  //         .login(permissions: const ['email', 'public_profile']);

  //     if (loginResult.status == LoginStatus.success) {
  //       AuthCredential credential = FacebookAuthProvider.credential(
  //           loginResult.accessToken?.token ?? "");
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //       saveTokenAndNavigateToNext();
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     isSigningIn = false;
  //     notifyListeners();

  //     GlobalSnackBar.show(message: 'Please enter ${e.message}');
  //   } catch (e) {
  //     isSigningIn = false;
  //     notifyListeners();

  //     GlobalSnackBar.show(message: 'Facebook login cancelled');
  //   } finally {
  //     isSigningIn = false;
  //     notifyListeners();
  //   }
  // }