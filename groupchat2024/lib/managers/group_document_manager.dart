import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat2024/models/group.dart';

class GroupDocumentManager {
  Group? latestGroup;
  final CollectionReference _ref;

  static final GroupDocumentManager instance =
      GroupDocumentManager._privateConstructor();

  GroupDocumentManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kGroupsCollectionPath);

  StreamSubscription startListening({
    required String groupDocumentId,
    required Function observer,
  }) =>
      _ref.doc(groupDocumentId).snapshots().listen(
          (DocumentSnapshot documentSnapshot) {
        latestGroup = Group.from(documentSnapshot);
        observer();
      }, onError: (error) {
        print("Error listening for Group $error");
      });

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  Future<void> delete() => _ref.doc(latestGroup!.documentId!).delete();

  Future<void> updateName({
    required String name,
  }) {
    return _ref.doc(latestGroup!.documentId!).update({
      kGroupName: name,
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  void addEmail(String emailToAdd) {
    memberEmails.add(emailToAdd);
    updateMemberEmails(memberEmails: memberEmails);
  }

  void removeEmail(String emailToRemove) {
    memberEmails.remove(emailToRemove);
    updateMemberEmails(memberEmails: memberEmails);
  }

  Future<void> updateMemberEmails({
    required List<String> memberEmails,
  }) {
    return _ref.doc(latestGroup!.documentId!).update({
      kGroupMemberEmails: memberEmails,
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  void clearLatest() {
    latestGroup = null;
  }

  String get name => latestGroup?.name ?? "";
  List<String> get memberEmails => latestGroup?.memberEmails ?? [];
  String get ownerEmail => latestGroup?.ownerEmail ?? "";
}
