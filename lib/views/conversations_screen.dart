import 'package:flutter/material.dart';
import 'package:flutterchat/authanticate/constants.dart';
import 'package:flutterchat/services/database.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId, {Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();
  late Stream chatMessageStream;

  @override
  void initState() {
    chatMessageStream = databaseMethods.getConversationMessages(widget.chatRoomId);
    setState(() {
    });
    super.initState();
  }

   Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
            // print(snapshot.data!.docs[index]["message"]);
            return MessageTile(
                snapshot.data!.docs[index]["message"],
              snapshot.data!.docs[index]["sendBy"] == Constant.myName,
            );
            }): Container();
        }
    );
  }

  sendMessage() {
    if(messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constant.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Connect', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54ffffff),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            hintText: "Message...",
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print(messageController.text);
                        sendMessage();
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
                          child: Icon(Icons.send, color: Colors.white,)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe? 0: 24, right: isSendByMe? 24: 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe? [
              Color(0xff007ef4),
              Color(0xff2a75bc)
            ]: [
              Color(0x1affffff),
              Color(0x1affffff)
            ]
          ),
          borderRadius: isSendByMe?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
              ):
              BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)
              )
        ),
        child: Text(message, style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),),
      ),
    );
  }
}
