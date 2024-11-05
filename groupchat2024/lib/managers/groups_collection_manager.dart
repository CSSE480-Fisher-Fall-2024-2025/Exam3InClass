import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat2024/managers/auth_manager.dart';
import 'package:groupchat2024/models/group.dart';

class GroupsCollectionManager {
  final CollectionReference _ref;

  static final GroupsCollectionManager instance =
      GroupsCollectionManager._privateConstructor();

  GroupsCollectionManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kGroupsCollectionPath);

  Future<void> add({
    required String name,
    required String emailCsv,
  }) {
    final memberEmails = <String>[];
    final emailSplit = emailCsv.split(",");
    for (String email in emailSplit) {
      memberEmails.add(email.trim());
    }
    memberEmails.add(AuthManager.instance.email);
    return _ref.add({
      kGroupOwnerEmail: AuthManager.instance.email,
      kGroupName: name,
      kGroupMemberEmails: memberEmails.toSet().toList(),
      kGroupCreated: Timestamp.now(),
    }).then((DocumentReference docRef) {
      print("The add is finished, the doc id was ${docRef.id}");
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  Query<Group> get allGroupsQuotesQuery =>
      _ref.orderBy(kGroupName).withConverter(
            fromFirestore: (documentSnapshot, _) =>
                Group.from(documentSnapshot),
            toFirestore: (group, _) => group.toJsonMap(),
          );

  Query<Group> get onlyMyGroupsQuery => allGroupsQuotesQuery
      .where(kGroupMemberEmails, arrayContains: AuthManager.instance.email);
}
