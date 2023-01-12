import 'dart:io';

import 'package:chat_app/widgets/auth/auth_screen_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitForm(
    String email,
    String password,
    String username,
    bool isLogin,
    File pickedImage,
  ) async {
    UserCredential authResult;
    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');

        await ref.putFile(pickedImage).whenComplete(() async {
          final url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('Users')
              .doc(authResult.user!.uid)
              .set({
            'username': username,
            'email': email,
            'imageUrl': url,
          });
        });
      }
    } on FirebaseAuthException catch (error) {
      String? errorMessage = 'An error occured, please check your credentials!';
      if (errorMessage != null) {
        errorMessage = error.message;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(errorMessage!),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthScreenWidget(_submitForm),
    );
  }
}
