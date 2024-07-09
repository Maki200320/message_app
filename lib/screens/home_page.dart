import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging/screens/chat_room.dart';
import 'package:messaging/services/chat_service.dart';
import 'package:messaging/services/sign_up.dart';

import '../components/user_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ChatService _service = ChatService();
  final SignUpFirebase _authService = SignUpFirebase();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('H O M E '),
          actions: [
            IconButton(
              onPressed: () {
                _authService.signOut(context);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _service.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("E R R O R"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Get the current user's email
        final currentUserEmail = _authService.getCurrentUser();

        return ListView(
          children: snapshot.data!.map<Widget>((userData) {
            if (userData['email'] != currentUserEmail) {
              return _buildUserListItem(userData, context);
            } else {
              return Container(); // Skip current user
            }
          }).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if(userData['email'] != _authService.getCurrentUser()!.email){
      return Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey
        ),
        child: UserTile(
          text: userData['email'],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ChatRoom(receiverID: userData['uid'], receiverEmail: userData['email']);
                },
              ),
            );
          },
        ),
      );
    }else{
      return Container();
    }
  }
}
