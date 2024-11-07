import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat2024/models/group.dart';
import 'package:groupchat2024/models/message.dart';
import 'package:intl/intl.dart';

class MessageDocumentManager {
  Message? latestMessage;
  String? _currentGroupDocumentId;
  final CollectionReference _primaryRef;

  static final MessageDocumentManager instance =
      MessageDocumentManager._privateConstructor();

  MessageDocumentManager._privateConstructor()
      : _primaryRef =
            FirebaseFirestore.instance.collection(kGroupsCollectionPath);

  CollectionReference get _currentMessagesColectionRef => _primaryRef
      .doc(_currentGroupDocumentId)
      .collection(kMessagesCollectionPath);

  DocumentReference get _currentMessageRef =>
      _currentMessagesColectionRef.doc(latestMessage!.documentId!);

  StreamSubscription startListening({
    required String groupDocumentId,
    required String messageDocumentId,
    required Function observer,
  }) {
    _currentGroupDocumentId = groupDocumentId;
    return _currentMessagesColectionRef
        .doc(messageDocumentId)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      latestMessage = Message.from(documentSnapshot);
      observer();
    }, onError: (error) {
      print("Error listening for Message $error");
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  Future<void> delete() => _currentMessageRef.delete();

  Future<void> updateText(String text) {
    return _currentMessageRef.update({
      kMessageText: text,
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  void restore(Message messageToRestore) {
    _currentMessagesColectionRef.doc(messageToRestore.documentId!).set({
      kMessageText: messageToRestore.text,
      kMessageAuthorEmail: messageToRestore.authorEmail,
      kMessageCreated: messageToRestore.created,
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  void clearLatest() {
    latestMessage = null;
  }

  String get text => latestMessage?.text ?? "";
  String get authorEmail => latestMessage?.authorEmail ?? "";
  String get createdString {
    if (latestMessage != null) {
      return "";
    }
    DateTime dateTime = latestMessage!.created.toDate();
    return DateFormat("MM/dd/yyyy hh:mm a").format(dateTime);
  }
}
