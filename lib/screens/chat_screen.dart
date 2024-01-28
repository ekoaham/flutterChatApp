import 'package:flutter/material.dart';
import 'package:flash_chat_app_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fire = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = '/fourth';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String messageText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

  }
  void getCurrentUser() async{
    try{
      final user = await _auth.currentUser;
      if(user != Null){
        loggedInUser = user!;
        print(loggedInUser?.email);
      }
    }
    catch(e){}
  }
  void messageStream() async{
    await for(var snapshot in _fire.collection('messages').snapshots()){
      for(var message in snapshot.docs){
        print(message.data());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;

                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      _fire.collection('messages').add(
                        {
                          'text': messageText,
                          'sender': loggedInUser?.email
                        }
                      );
                      messageController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fire.collection('messages').snapshots(),
        builder: (context, snapshot){

          if(!snapshot.hasData){
            return CircularProgressIndicator(
              color: Colors.lightBlueAccent,
            );
          }
          final messages = snapshot.data!.docs.reversed;
          List<Widget> messageWidgets = [];
          for(var message in messages!){
            final messageText = message.get('text');
            final messageSender = message.get('sender');

            final currentuser = loggedInUser?.email;
            final messageWidget = MessageBubble(messageText, messageSender, currentuser == messageSender,currentuser == messageSender);
            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: messageWidgets,
            ),
          );


        }
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble(this.message,this.sender, this.isMe, this.align);
  final String message;
  final String sender;
  final bool isMe;
  final bool align;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: align? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.white54
          ),
          ),
          Material(
            borderRadius: align?BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)) :
            BorderRadius.only(topRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text(
                      message,
                  // '$message from $sender',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black45
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
