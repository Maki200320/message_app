import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging/services/sign_up.dart';

import '../services/chat_service.dart';

class ChatRoom extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatRoom({super.key, required this.receiverID, required this.receiverEmail});

  final SignUpFirebase _auth = SignUpFirebase();
  final ChatService _service = ChatService();


  final TextEditingController _messageController = TextEditingController();

  void sendMessage()async{
    if(_messageController.text.isNotEmpty){
      await _service.sendMessage(receiverID, _messageController.text);

      _messageController.clear();
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
           title: Text(receiverEmail),
         ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()
          ),
          _buildUserInput()
        ],
      ),
    ));
  }
  Widget _buildMessageList() {
    //MAY CAUSE ERROR
    String senderID = _auth.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: _service.getMessages(senderID, receiverID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No messages'));
        }

        // final QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
        // final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }


  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderId'] == _auth.getCurrentUser()!.uid;

    // align message to the right if sender is the current user
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.bottomLeft;


    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.cyanAccent : Colors.amber,
                  borderRadius: isCurrentUser ?  const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20)) : const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),

        child: Text(data['message'])),
          ],
        ));
  }

  Widget _buildUserInput(){
    return Row(
      children: [
        Expanded(child: TextField(
    controller: _messageController,
      decoration: InputDecoration(
        hintText: 'Enter your message...',

      ),
    ),
    ),
    IconButton(
    icon: Icon(Icons.send),
    onPressed: sendMessage
    ),
      ],
    );
  }
}

