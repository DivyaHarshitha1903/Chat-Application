import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_againapp1/widgets/chat/message_bubble.dart';
class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, futuresnapshot) {
        if (futuresnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy(
                  'createdat',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, chatsnapshot) {
              if (chatsnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatsnapshot.data.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  chatDocs[index]['text'],
                  chatDocs[index]['username'],
                  chatDocs[index]['userimage'],
                  chatDocs[index]['userid'] == futuresnapshot.data.uid,
                ),
              );
            });
      },
    );
  }
}