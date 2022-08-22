import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/services/database.dart';
import 'package:flutterchat/views/conversations_screen.dart';

import '../authanticate/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot? querySnapshot;

  initiateSearch() async{
    querySnapshot = await databaseMethods.getUserByUsername(searchTextEditingController.text);
    setState(() {
    });
  }

  Widget searchList() {
    return querySnapshot != null?  ListView.builder(
        itemCount: querySnapshot?.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SearchTile(
              userName: querySnapshot?.docs[index].get("name"),
              userEmail: querySnapshot?.docs[index].get("email"),);
        }): Container();
  }

  createChatRoomAndStartConversation(String userName) {
    if(userName != Constant.myName) {
      List<String> users = [userName, Constant.myName];
      String chatRoomId = getChatRoomId(userName, Constant.myName);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
    }else {
      print("You can not sen message to yourself");
    }
  }

  Widget SearchTile({required String userName, required String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),),
              SizedBox(height: 7,),
              Text(userEmail, style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue,
              ),
              padding:EdgeInsets.symmetric(horizontal: 16, vertical: 16,),
              child: Text('Message', style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Connect', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54ffffff),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "search users...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x36ffffff),
                            Color(0x0fffffff),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(Icons.search, color: Colors.white,)
                    ),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  }
  return "$a\_$b";
}

