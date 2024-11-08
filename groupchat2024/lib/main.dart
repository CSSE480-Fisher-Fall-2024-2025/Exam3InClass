import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:groupchat2024/pages/account/login_front_page.dart';
import 'firebase_options.dart';

// Reminders of commands I ran:
//  for pubspec.yaml I just copied over lines
//  dart pub global activate flutterfire_cli
//  flutterfire configure
//  flutter build web
//  firebase init

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Group Chat",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginFrontPage(),
    );
  }
}
