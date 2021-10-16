import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplifygqlchattest/screen/chatList.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';
import 'package:get/get.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    // Add the following line to add API plugin to your app
    Amplify.addPlugin(AmplifyAPI());

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetMaterialApp(
      home: Scaffold(
        body: Container(child: ChatList())
      ),
    );
  }
}

void createData() async {
  try {
    String graphQLDocument =
    '''mutation CreateTodo(\$name: String!, \$description: String) {
              createTodo(input: {name: \$name, description: \$description}) {
                id
                name
                description
              }
        }''';
    var variables = {
      "name": "my first todo",
      "description": "todo description",
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
      "title": "my first todo",
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

void readData() async {
  try {
    String graphQLDocument = '''query listTodos {
      listTodos {
        items {
          id
        }
      }
    }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument,
            variables: {'id': '8d054400-385d-4bd1-b76d-a5972a98ed47'}));

    var response = await operation.response;
    var data = response.data;

    print('Query result: ' + data);
  } on ApiException catch (e) {
    print('Query failed: $e');
  }
}

void readData2() async {
  try {
    String graphQLDocument = '''query listChatData {
      listChatData {
        items {
          id
        }
      }
    }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument,
            variables: {'id': '8d054400-385d-4bd1-b76d-a5972a98ed47'}));

    var response = await operation.response;
    var data = response.data;

    print('Query result: ' + data);
  } on ApiException catch (e) {
    print('Query failed: $e');
  }
}


void subscribeData() async{
  try {
    String graphQLDocument = '''subscription OnCreateTodo {
        onCreateTodo {
          id
          name
          description
        }

      }''';

    var operation = Amplify.API.subscribe(
        request: GraphQLRequest<String>(document: graphQLDocument),
        onData: (event) {
          print('Subscription event data received: ${event.data}');
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

