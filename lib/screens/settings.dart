import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {

  Future<void> _logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');
      await FirebaseAuth.instance.signOut();

      // Navigate to login screen or any other screen after logout
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(), // Replace with your actual login screen widget
        ),
      );
    } catch (e) {
      print('Error logging out: $e');
      // Handle error logging out
    }
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child:  Scaffold(
        appBar: AppBar(
          title: Text('S E T T I N G'),

        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0,),
            TextButton(
                onPressed: (){
                  _logout(context);
                }, child: const Row(
              children: [
               Icon( Icons.logout),
                Text("L O G O U T"),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
