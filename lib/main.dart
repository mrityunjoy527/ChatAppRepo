import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/authanticate/helperfunctions.dart';
import 'package:flutterchat/views/chatRoom.dart';
import 'authanticate/authanticate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    isLoggedIn = (await HelperFunctions.getUserLoggedInSharedPreference())!;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145c9e),
        scaffoldBackgroundColor: Color(0xff1f1f1f)
      ),
      home: isLoggedIn==true ? ChatRoom() : Authenticate(),
    );
  }
}
class IamBlank extends StatelessWidget {
  const IamBlank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}

