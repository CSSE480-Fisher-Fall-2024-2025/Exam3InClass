import 'dart:async';

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groupchat2024/managers/auth_manager.dart';
import 'package:groupchat2024/managers/groups_collection_manager.dart';
import 'package:groupchat2024/models/group.dart';

class GroupsListPage extends StatefulWidget {
  const GroupsListPage({super.key});

  @override
  State<GroupsListPage> createState() => _GroupsListPageState();
}

class _GroupsListPageState extends State<GroupsListPage> {
  final groupNameTextEditingController = TextEditingController();
  final emailCsvTextEditingController = TextEditingController();
  UniqueKey? _logoutObserverKey;

  @override
  void initState() {
    super.initState();
    _logoutObserverKey = AuthManager.instance.addLogoutObserver(() {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    groupNameTextEditingController.dispose();
    emailCsvTextEditingController.dispose();
    AuthManager.instance.removeObserver(_logoutObserverKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Group List"),
      ),
      body: FirestoreListView(
        query: GroupsCollectionManager.instance.onlyMyGroupsQuery,
        itemBuilder: (context, snapshot) {
          final Group g = snapshot.data();
          return ListTile(
            onTap: () {
              print("TODO: Show the Message List Page for $g");
            },
            leading: const Icon(Icons.chat),
            title: Text(
              g.name,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "${g.memberEmails.length} members",
            ),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: const Text(
                "Group Chat",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 28.0,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text("Edit Profile"),
              onTap: () {
                Navigator.of(context).pop();
                print("TODO: Show the edit profile page");
              },
            ),
            const Spacer(),
            const Divider(
              thickness: 2.0,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).pop();
                AuthManager.instance.signOut();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateGroupDialog();
        },
        tooltip: "Add Group",
        child: const Icon(Icons.add),
      ),
    );
  }

  void showCreateGroupDialog() {
    groupNameTextEditingController.text = "";
    emailCsvTextEditingController.text = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create a Group"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: groupNameTextEditingController,
              decoration: const InputDecoration(
                labelText: "Group Name",
                border: UnderlineInputBorder(),
              ),
            ),
            TextField(
              controller: emailCsvTextEditingController,
              decoration: const InputDecoration(
                labelText: "Member Emails",
                border: UnderlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // New so must be better?
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
