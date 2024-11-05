import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat2024/models/firestore_model_utils.dart';

const kMessagesCollectionPath = "Messages";
const kMessageAuthorEmail = "authorEmail";
const kMessageCreated = "created";
const kMessageText = "text";

class Message {
  String? documentId;
  String authorEmail;
  Timestamp created;
  String text;

  Message({
    this.documentId,
    required this.authorEmail,
    required this.created,
    required this.text,
  });

  Message.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          authorEmail:
              FirestoreModelUtils.getStringField(doc, kMessageAuthorEmail),
          created: FirestoreModelUtils.getTimestampField(doc, kMessageCreated),
          text: FirestoreModelUtils.getStringField(doc, kMessageText),
        );

  Map<String, Object?> toJsonMap() => {
        kMessageAuthorEmail: authorEmail,
        kMessageCreated: created,
        kMessageText: text,
      };

  @override
  String toString() {
    return "Text: $text  from: $authorEmail";
  }
}
