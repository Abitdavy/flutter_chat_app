import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userName;

  MessageBubble(this.message, this.isMe, this.userName);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 140,
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 4,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? Colors.grey[400]
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.black87 : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
