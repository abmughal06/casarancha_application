import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:casarancha/resources/firebase_cloud_messaging.dart';
import 'package:casarancha/screens/auth/setup_profile_details.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

import '../../../resources/localization_text_strings.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/snackbar.dart';

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
        isSigningIn = false;
        notifyListeners();
        GlobalSnackBar.show(message: 'Please enter ${e.message}');
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
      Get.offAll(() => const DashBoard());
    } else {
      Get.offAll(() => const SetupProfileScreen());
    }
  }

  //SIGN IN METHOD
  Future<void> signIn({String? email, String? password}) async {
    if (checkValidDataLogin(email: email, password: password)) {
      try {
        isSigningIn = true;
        notifyListeners();

        await firebaseAuth.signInWithEmailAndPassword(
            email: email!, password: password!);
        // .whenComplete(() => );
        saveTokenAndNavigateToNext();
      } on FirebaseAuthException catch (e) {
        isSigningIn = false;
        notifyListeners();

        GlobalSnackBar.show(message: 'Please enter ${e.message}');
      } finally {
        isSigningIn = false;
        notifyListeners();
      }
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
      } finally {
        isSigningIn = false;
        notifyListeners();
      }
    }
  }

  Future<void> callFaceBookSignIn() async {
    try {
      isSigningIn = true;
      notifyListeners();

      LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: const ['email', 'public_profile']);

      if (loginResult.status == LoginStatus.success) {
        AuthCredential credential = FacebookAuthProvider.credential(
            loginResult.accessToken?.token ?? "");
        await FirebaseAuth.instance.signInWithCredential(credential);
        saveTokenAndNavigateToNext();
      }
    } on FirebaseAuthException catch (e) {
      isSigningIn = false;
      notifyListeners();

      GlobalSnackBar.show(message: 'Please enter ${e.message}');
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
    } finally {
      isSigningIn = false;
      notifyListeners();
    }
  }

  Future<void> callTwitterSignIn() async {
    try {
      isSigningIn = true;
      notifyListeners();

      TwitterLogin login = TwitterLogin(
          apiKey: "HaPI0dQRItR56omPwCGmNBoVi",
          apiSecretKey: "Y3oaX4cUFdMldsr3ZefKxOjC8WVoqVhHFUloOTTZ4y1p5mCf3P",
          redirectURI: "https://casa-rancha.firebaseapp.com/__/auth/handler");
      AuthResult authResult = await login.loginV2();
      if (authResult.authToken != null && authResult.authTokenSecret != null) {
        AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: authResult.authToken!,
            secret: authResult.authTokenSecret!);
        FirebaseAuth.instance.signInWithCredential(credential);
        saveTokenAndNavigateToNext();
      }
    } on FirebaseAuthException catch (e) {
      isSigningIn = false;
      notifyListeners();

      GlobalSnackBar.show(message: 'Please enter ${e.message}');
    } finally {
      isSigningIn = false;
      notifyListeners();
    }
  }

  bool checkValidDataLogin({String? email, String? password}) {
    if (email!.isEmpty) {
      GlobalSnackBar.show(message: 'Please enter $strEmailAddress');
      return false;
    } else if (!EmailValidator.validate(email)) {
      GlobalSnackBar.show(message: 'Please enter valid $strEmailAddress');
      return false;
    } else if (password!.isEmpty) {
      GlobalSnackBar.show(message: 'Please enter $strPassword');
      return false;
    }
    return true;
  }

  bool checkValidDataRegister(
      {String? email, String? password, String? confirmPassword}) {
    if (email!.isEmpty) {
      GlobalSnackBar.show(message: 'Please enter $strEmailAddress');
      return false;
    } else if (!EmailValidator.validate(email.trim())) {
      GlobalSnackBar.show(message: 'Please enter valid $strEmailAddress');
      return false;
    } else if (password!.isEmpty) {
      GlobalSnackBar.show(message: 'Please enter $strPassword');
      return false;
    } else if (password.length < AppConstant.passwordMinText) {
      GlobalSnackBar.show(
          message:
              '$strPassword should be minimum ${AppConstant.passwordMinText} characters');
      return false;
    } else if (confirmPassword!.isEmpty) {
      GlobalSnackBar.show(message: 'Please enter $strConfirmPassword');
      return false;
    } else if (password != confirmPassword) {
      GlobalSnackBar.show(
          message: '$strPassword & $strConfirmPassword must be same');
      return false;
    }
    return true;
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
