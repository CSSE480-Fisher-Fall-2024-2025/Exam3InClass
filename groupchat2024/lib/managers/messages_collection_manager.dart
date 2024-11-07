import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat2024/managers/auth_manager.dart';
import 'package:groupchat2024/models/group.dart';
import 'package:groupchat2024/models/message.dart';

class MessageCollectionManager {
  final CollectionReference _primaryRef;
  String? _currentGroupDocumentId;

  static final MessageCollectionManager instance =
      MessageCollectionManager._privateConstructor();

  MessageCollectionManager._privateConstructor()
      : _primaryRef =
            FirebaseFirestore.instance.collection(kGroupsCollectionPath);

  Future<void> add({
    required String text,
  }) {
    return _primaryRef
        .doc(_currentGroupDocumentId)
        .collection(kMessagesCollectionPath)
        .add({
      kMessageText: text,
      kMessageAuthorEmail: AuthManager.instance.email,
      kMessageCreated: Timestamp.now(),
    }).then((DocumentReference docRef) {
      print("The add is finished, the doc id was ${docRef.id}");
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  Query<Message> allGroupMessagesQuery(String groupDocumentId) {
    _currentGroupDocumentId = groupDocumentId; // Just to help add.
    return _primaryRef
        .doc(_currentGroupDocumentId)
        .collection(kMessagesCollectionPath)
        .orderBy(kMessageCreated)
        .withConverter(
          fromFirestore: (documentSnapshot, _) =>
              Message.from(documentSnapshot),
          toFirestore: (message, _) => message.toJsonMap(),
        );
  }
}
