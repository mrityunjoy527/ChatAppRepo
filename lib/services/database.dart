import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterchat/authanticate/constants.dart';

class DatabaseMethods {

  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();
  }
  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: userEmail).get();
  }
  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }
  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e) {
      print(e);
    });
  }
  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").add(messageMap).catchError((e) {
      print(e);
    });
  }
  getConversationMessages(String chatRoomId) {
    return FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").orderBy("time", descending: false).snapshots();
  }
  getChatRooms(String userName) {
    return FirebaseFirestore.instance.collection("ChatRoom").where("users", arrayContains: userName).snapshots();
  }
}