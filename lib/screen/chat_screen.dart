import 'package:chat_app/widgets/chat/chat_message.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
              height: 120,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.only(top: 15, left: 15),
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile',
                style: TextStyle(fontSize: 40),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, size: 30),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).errorColor),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
      ),
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
