import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var newMessage = '';
  var _controller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'Text': newMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
    });
    _controller.clear();
    setState(() {
      newMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'send message'),
              onChanged: (value) {
                setState(() {
                  newMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: newMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
