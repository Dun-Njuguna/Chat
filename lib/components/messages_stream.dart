import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message_bubble.dart';

// ignore: must_be_immutable
class MessagesStream extends StatelessWidget {
  MessagesStream({this.fireStoreInstance, this.user});
  FirebaseFirestore fireStoreInstance;
  User user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStoreInstance.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        var currentUserEmail = user.email;
        for (var message in messages) {
          final messageBubble = MessageBubble(
            sender: message.get('sender'),
            text: message.get('message'),
            isMe: currentUserEmail == message.get('sender'),
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            reverse: true,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
