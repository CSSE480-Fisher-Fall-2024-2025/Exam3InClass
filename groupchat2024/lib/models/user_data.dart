import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat2024/models/firestore_model_utils.dart';

const kUserDatasCollectionPath = "UserDatas";
const kUserDataCreated = "created";
const kUserDataFirstName = "firstName";
const kUserDataLastName = "lastName";

class UserData {
  String? documentId;
  Timestamp created;
  String displayName;
  String imageUrl;

  UserData({
    this.documentId,
    required this.created,
    required this.displayName,
    required this.imageUrl,
  });

  // Need for listening.
  UserData.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          created: FirestoreModelUtils.getTimestampField(doc, kUserDataCreated),
          displayName:
              FirestoreModelUtils.getStringField(doc, kUserDataDisplayName),
          imageUrl: FirestoreModelUtils.getStringField(doc, kUserDataImageUrl),
        );

  @override
  String toString() {
    return "Display Name: $displayName";
  }
}
