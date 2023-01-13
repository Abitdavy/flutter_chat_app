import 'dart:io';

import 'package:chat_app/widgets/chat/chat_message.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? name;
  String? userimage;
  File? imageXFile;

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((message) {
      print('foreground message title : ${message.notification!.title}');
      print('foreground message body : ${message.notification!.body}');
    });
    // FirebaseMessaging.onBackgroundMessage((message) {
    //   print('background message title : ${message.notification!.title}');
    //   print('background message: ${message.notification!.body}');
    //   return Future.delayed(Duration(seconds: 0));
    // });
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    _getUserData();
    super.initState();
  }

  Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
    print('background message title: ${message.notification?.title}');
    print('background message: ${message.notification?.body}');
    return Future.delayed(Duration.zero); //Mock Future
  }

  Future _getUserData() async {
    final getData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
          (value) {
            name = value.data()!['username'];
            userimage = value.data()!['userImage'];
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi User'),
        // actions: [
        //   DropdownButton(iconEnabledColor: Colors.white,items: [
        //     DropdownMenuItem(
        //       child: Container(
        //         child: Row(
        //           children: [
        //             Icon(Icons.exit_to_app),
        //             SizedBox(
        //               width: 8,
        //             ),
        //             Text('Logout')
        //           ],
        //         ),
        //       ),
        //       value: 'logout',
        //     ),
        //   ], onChanged: (value) {
        //     if(value == 'logout') {
        //       FirebaseAuth.instance.signOut();
        //     }
        //   },)
        // ],
      ),
      drawer: Drawer(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  //backgroundImage: NetworkImage(userimage!)
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'profile',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, size: 30),
            title: Text(
              'Logout',
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).errorColor),
            ),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      )),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ChatMessage(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
