import 'package:amplifygqlchattest/models/chatModel.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  ChatTile(this._chat);

  final Chat _chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(_chat.content),
      subtitle: Text("${_chat.title}"),
    );
  }
}
