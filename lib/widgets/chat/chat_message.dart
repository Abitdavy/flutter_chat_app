import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (context, futuresnapshot) {
          if (futuresnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = snapshot.data!.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (context, index) => MessageBubble(
                  chatDocs[index]['Text'],
                  chatDocs[index]['userId'] == futuresnapshot.data!.uid,
                  chatDocs[index]['username'],
                  chatDocs[index]['userImage'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
