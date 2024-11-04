import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat2024/models/firestore_model_utils.dart';

const kGroupsCollectionPath = "Groups";
const kGroupCreated = "created";
const kGroupMemberEmails = "memberEmails";
const kGroupName = "name";
const kGroupOwnerEmail = "ownerEmail";

class Group {
  String? documentId;
  Timestamp created;
  List<String> memberEmails;
  String name;
  String ownerEmail;

  Group({
    this.documentId,
    required this.created,
    required this.memberEmails,
    required this.name,
    required this.ownerEmail,
  });

  // Need for listening.
  Group.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          created: FirestoreModelUtils.getTimestampField(doc, kGroupCreated),
          memberEmails:
              FirestoreModelUtils.getStringListField(doc, kGroupMemberEmails),
          name: FirestoreModelUtils.getStringField(doc, kGroupName),
          ownerEmail: FirestoreModelUtils.getStringField(doc, kGroupOwnerEmail),
        );

  // Only need when using Firebase UI Firestore
  Map<String, Object?> toJsonMap() => {
        kGroupCreated: created,
        kGroupMemberEmails: memberEmails,
        kGroupName: name,
        kGroupOwnerEmail: ownerEmail,
      };

  @override
  String toString() {
    return "Name: $name  members emails: $memberEmails";
  }
}
