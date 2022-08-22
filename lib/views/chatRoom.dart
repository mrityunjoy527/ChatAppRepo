import 'package:flutter/material.dart';
import 'package:flutterchat/authanticate/constants.dart';
import 'package:flutterchat/authanticate/helperfunctions.dart';
import 'package:flutterchat/services/database.dart';
import 'package:flutterchat/views/conversations_screen.dart';
import 'package:flutterchat/views/search.dart';

import '../authanticate/authanticate.dart';
import '../services/auth.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream? chatRoomStream;

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData? ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                // print(snapshot.data!.docs[index]["chatRoomId"]);
                return ChatRoomTile(
                    snapshot.data!.docs[index]["chatRoomId"]
                        .toString().replaceAll("_", "").replaceAll(Constant.myName, ""),
                    snapshot.data!.docs[index]["chatRoomId"]
                );
              }): Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constant.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    chatRoomStream = databaseMethods.getChatRooms(Constant.myName);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Connect', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app_outlined)
            ),
          ),
        ],
      ),
      body: chatMessageList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String charRoomId;
  ChatRoomTile(this.userName, this.charRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(charRoomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              child: Text(userName.substring(0, 1).toUpperCase()),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            SizedBox(width: 8,),
            Text(userName, style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),)
          ],
        ),
      ),
    );
  }
}

