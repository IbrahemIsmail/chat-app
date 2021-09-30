import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import './messageBubble.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var _userId = '';

  Future<void> getUid() async {
    final user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _userId = user.uid;
    });
  }

  @override
  void initState() {
    getUid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('createdAt')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            final docs = snapshot.data.documents;
            return ListView.builder(
              // reverse: true,
              itemCount: docs.length,
              itemBuilder: (ctx, i) {
                return MessageBubble(
                  docs[i]['text'],
                  docs[i]['userId'] == _userId,
                  docs[i]['username'],
                  docs[i]['imageUrl'],
                  key: ValueKey(docs[i].documentID),
                );
              },
            );
          },
        );
      },
    );
  }
}
