import 'dart:io';

import 'package:chat_flutter/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<void> _sendMessage({String? text, File? imageFile}) async {
    Map<String, dynamic> data = {};

    if (imageFile != null) {
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imageFile);

      String url = await taskSnapshot.ref.getDownloadURL();
      data['imageUrl'] = url;
    }

    if(text != null) data['text'] = text;

    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo!'),
        elevation: 0,
      ),
      body: TextComposer(
        sendMessage: _sendMessage,
      ),
    );
  }
}
