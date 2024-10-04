import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class FirebaseCloudAuthService {
  final _scopes = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging"
  ];

  Future<String> getAccessToken() async {
    final serviceAccountJson =
        await rootBundle.loadString("assets/json/casa-rancha.json");
    final jsonDecode = json.decode(serviceAccountJson);

    final credentials = auth.ServiceAccountCredentials.fromJson(jsonDecode);

    final client = await auth.clientViaServiceAccount(credentials, _scopes);

    final accessCredentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      credentials,
      _scopes,
      client,
    );

    client.close();

    return accessCredentials.accessToken.data;
  }
}
