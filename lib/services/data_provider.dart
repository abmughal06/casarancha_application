import 'package:casarancha/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataProvider {
  final FirebaseFirestore firebaseFirestore;
  DataProvider(this.firebaseFirestore);

  Stream<UserModel?> userData() {
    return firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }
}
