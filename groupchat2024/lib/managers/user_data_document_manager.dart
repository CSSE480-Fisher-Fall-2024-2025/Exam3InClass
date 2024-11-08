import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat2024/managers/auth_manager.dart';
import 'package:groupchat2024/models/user_data.dart';

class UserDataDocumentManager {
  UserData? latestUserData;
  final CollectionReference _ref;

  static final UserDataDocumentManager instance =
      UserDataDocumentManager._privateConstructor();

  UserDataDocumentManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kUserDatasCollectionPath);

  StreamSubscription startListening({
    required String documentId,
    required Function observer,
  }) =>
      _ref.doc(documentId).snapshots().listen(
          (DocumentSnapshot documentSnapshot) {
        latestUserData = UserData.from(documentSnapshot);
        observer();
      }, onError: (error) {
        print("Error listening for Movie Quote $error");
      });

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  void createUserDataFromCurrentUser({
    required String firstName,
    required String lastName,
    required String email,
  }) {
    _ref.doc(email).set({
      kUserDataCreated: Timestamp.now(),
      kUserDataFirstName: firstName,
      kUserDataLastName: lastName,
    }).catchError((err) {
      print("Error making the UserData ${err.toString()}");
    });
  }

  Future<void> update({
    required String firstName,
    required String lastName,
  }) {
    return _ref.doc(AuthManager.instance.email).update({
      kUserDataFirstName: firstName,
      kUserDataLastName: lastName,
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  String get firstName => latestUserData?.firstName ?? "";
  String get lastName => latestUserData?.lastName ?? "";
  String get name => latestUserData?.name ?? "";

  void clearLatest() {
    latestUserData = null;
  }
}
