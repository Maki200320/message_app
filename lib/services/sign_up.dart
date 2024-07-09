import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/message.dart';
import '../screens/home_page.dart';

class SignUpFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //getting current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  //This handle Sign UP
  Future<void> signUpWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user data to Firestore
      _firestore.collection('users').doc(userCredential.user!.uid).set(
        {
        'uid': userCredential.user!.uid,
        'email': email,
          'password': password
        }
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signInWithEmailPassword(String email, String password,
      BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,

      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', userCredential.user!.uid);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>
            HomePage()), // Replace with your HomePage widget
      );
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'password': password
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('uid');  // Clear stored UID

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),  // Replace with your login page widget
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}




