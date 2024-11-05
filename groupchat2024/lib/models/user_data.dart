import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat2024/models/firestore_model_utils.dart';

const kUserDatasCollectionPath = "UserDatas";
const kUserDataCreated = "created";
const kUserDataFirstName = "firstName";
const kUserDataLastName = "lastName";

class UserData {
  String? documentId;
  Timestamp created;
  String firstName;
  String lastName;

  UserData({
    this.documentId,
    required this.created,
    required this.firstName,
    required this.lastName,
  });

  UserData.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          created: FirestoreModelUtils.getTimestampField(doc, kUserDataCreated),
          firstName:
              FirestoreModelUtils.getStringField(doc, kUserDataFirstName),
          lastName: FirestoreModelUtils.getStringField(doc, kUserDataLastName),
        );

  String get name => "$firstName $lastName".trim();

  @override
  String toString() {
    return "Name: $name";
  }
}
