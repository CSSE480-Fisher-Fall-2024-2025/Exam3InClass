import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:groupchat2024/components/square_button.dart';
import 'package:groupchat2024/managers/auth_manager.dart';
import 'package:groupchat2024/managers/user_data_document_manager.dart';

class RegisterNewUserPage extends StatefulWidget {
  const RegisterNewUserPage({
    super.key,
  });

  @override
  State<RegisterNewUserPage> createState() => _RegisterNewUserPageState();
}

class _RegisterNewUserPageState extends State<RegisterNewUserPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameTextEditingController = TextEditingController();
  final lastNameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // TODO: Remove this later
    emailTextEditingController.text = "a@b.co";
    passwordTextEditingController.text = "123456";
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    firstNameTextEditingController.dispose();
    lastNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Create a New User"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: firstNameTextEditingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "First name can't be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "First Name",
                    hintText: "Enter a valid first name",
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: lastNameTextEditingController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Last Name",
                    hintText: "Optional",
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                TextFormField(
                  controller: emailTextEditingController,
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value)) {
                      return "Invalid Email Address";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: "Enter a valid email address",
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: passwordTextEditingController,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Passwords must be at least 6 characters";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Passwords must be 6 characters or more",
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                SquareButton(
                  displayText: "Create an Account",
                  onPressCallback: () async {
                    if (_formKey.currentState!.validate()) {
                      await AuthManager.instance.signInNewUser(
                        context: context,
                        emailAddress: emailTextEditingController.text,
                        password: passwordTextEditingController.text,
                      );
                      UserDataDocumentManager.instance
                          .createUserDataFromCurrentUser(
                        email: emailTextEditingController.text,
                        firstName: firstNameTextEditingController.text,
                        lastName: lastNameTextEditingController.text,
                      );

                      // AuthManager.instance.loginExistingUser(
                      //   context: context,
                      //   emailAddress: emailTextEditingController.text,
                      //   password: passwordTextEditingController.text,
                      // );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid Email or Password"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
