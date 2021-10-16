import 'package:amplifygqlchattest/controller/chatInfoController.dart';
import 'package:amplifygqlchattest/screen/chatRoom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: ListView(
          children: [
            Container(
              child: RaisedButton(
                child: Text("room 1"),
                onPressed: (){
                  print("hello");

                  Get.to(ChatRoom());
                },
              ),
            ),
            Container(
              child: RaisedButton(
                child: Text("room 2"),
                onPressed: (){
                  print("hello");
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
