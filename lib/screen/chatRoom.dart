import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplifygqlchattest/controller/chatInfoController.dart';
import 'package:amplifygqlchattest/main.dart';
import 'package:amplifygqlchattest/models/chatModel.dart';
import 'package:amplifygqlchattest/widgets/chatTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    subscribeData2();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatInfoController());
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                'clicks: ${controller.partyUUID.value}',
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Text("✏"),
              onPressed: (){
                // scrollController.jumpTo(scrollController.position.maxScrollExtent);
                createData2();
              },
            ),
            body: Container(
                child: FutureBuilder(
                  future: readData2(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data); // question
                      print(snapshot.error); // null
                      return ListView.builder(
                        // controller: scrollController,
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChatTile(snapshot.data[index]);
                        },
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.data); // null
                      print(snapshot.error); // 에러메세지 ex) 사용자 정보를 확인할 수 없습니다.
                      return Text("에러 일때 화면");
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )
            )
        )
    );
  }

  void subscribeData2() async{
    try {
      String graphQLDocument = '''subscription OnCreateTodo {
        onCreateChatData {
          content
          id
          title
        }

      }''';

      var operation = Amplify.API.subscribe(
          request: GraphQLRequest<String>(document: graphQLDocument),
          onData: (event) {
            print('Subscription event data received: ${event.data}');

            setState(() {

            });
          },
          onEstablished: () {
            print('Subscription established');
          },
          onError: (e) {
            print('Subscription failed with error: $e');
          },
          onDone: () {
            print('Subscription has been closed successfully');
          });
    } on ApiException catch (e) {
      print('Failed to establish subscription: $e');
    }

  }

}


Future<List<dynamic>> readData2() async {
  String data = "";
  try {
    String graphQLDocument = '''query {
      listChatData {
        items {
          id
          content
          title
        }
      }
    }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument,
            variables: {'id': '8d054400-385d-4bd1-b76d-a5972a98ed47'}));

    var response = await operation.response;
    data = response.data;


  } on ApiException catch (e) {
    print('Query failed: $e');
  }

  print(";");
  print((json.decode(data)['listChatData']["items"] ));

  var list = (json.decode(data)['listChatData']["items"])
      .map((data) => Chat.fromJson(data)).toList();

  print(list);
  return list;
}



void createData2() async {
  try {
    String graphQLDocument =
    '''mutation CreateChatData(\$title: String!, \$content: String!) {
              createChatData(input: {title: \$title, content: \$content}) {
                content
                title
              }
        }''';
    var variables = {
      "title": "${DateTime.now()}",
      "content": "todo description",
    };
    var request =
    GraphQLRequest<String>(document: graphQLDocument, variables: variables);

    var operation = Amplify.API.mutate(request: request);
    var response = await operation.response;

    var data = response.data;

    print('Mutation result: ' + data);
  } on ApiException catch (e) {
    print('Mutation failed: $e');
  }
}
