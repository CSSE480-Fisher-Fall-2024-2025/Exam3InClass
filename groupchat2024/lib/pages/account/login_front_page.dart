import 'package:flutter/material.dart';
import 'package:groupchat2024/components/square_button.dart';
import 'package:groupchat2024/managers/auth_manager.dart';
import 'package:groupchat2024/pages/account/register_new_user_page.dart';
import 'package:groupchat2024/pages/content/groups_list_page.dart';

class LoginFrontPage extends StatefulWidget {
  const LoginFrontPage({super.key});

  @override
  State<LoginFrontPage> createState() => _LoginFrontPageState();
}

class _LoginFrontPageState extends State<LoginFrontPage> {
  UniqueKey? _loginObserverKey;

  @override
  void initState() {
    super.initState();

    _loginObserverKey = AuthManager.instance.addLoginObserver(() {
      print("Login observed from the LoginFrontPage");
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const GroupsListPage(),
        ),
      );

      // Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  void dispose() {
    AuthManager.instance.removeObserver(_loginObserverKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                "Group Chat",
                style: TextStyle(
                  fontFamily: "Rowdies",
                  fontSize: 56.0,
                ),
              ),
            ),
          ),
          SquareButton(
            displayText: "Log in",
            onPressCallback: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         const LoginExistingUserPage(),
              //   ),
              // );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account yet?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegisterNewUserPage(),
                    ),
                  );
                },
                child: const Text("Sign Up Here"),
              ),
            ],
          ),
          const SizedBox(
            height: 60.0,
          ),
        ],
      ),
    );
  }
}
