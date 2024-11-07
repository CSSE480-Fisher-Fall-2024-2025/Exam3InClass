import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat2024/models/user_data.dart';

class UserDatasCollectionManager {
  var latestUserDatas = <String, UserData>{};
  final CollectionReference _ref;
  StreamSubscription? _userDatasStreamSubscription;

  static final UserDatasCollectionManager instance =
      UserDatasCollectionManager._privateConstructor();

  UserDatasCollectionManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kUserDatasCollectionPath);

  void startListening() {
    if (_userDatasStreamSubscription != null) {
      return; // Already listening
    }
    _userDatasStreamSubscription =
        _ref.snapshots().listen((QuerySnapshot querySnapshot) {
      latestUserDatas = {};
      for (DocumentSnapshot doc in querySnapshot.docs) {
        UserData ud = UserData.from(doc);
        latestUserDatas[ud.documentId!] = ud;
      }
    }, onError: (error) {
      print("Error listening for Movie Quotes $error");
    });
  }

  void stopListening() {
    _userDatasStreamSubscription?.cancel();
  }

  String getNameFromEmail(String email) {
    startListening(); // Just in case nobody ever called it to start the ball rolling.
    UserData? ud = latestUserDatas[email];
    if (ud != null && ud.name.isNotEmpty) {
      return ud.name;
    }
    return email;
  }
}
