
import 'package:example_app/screen/todoEdit.dart';
import 'package:example_app/screen/todolist.dart';
import 'package:example_app/screen/top.dart';
import 'package:example_app/screen/userlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/theme.dart';
import 'model/message.dart';
import 'model/todo.dart';
import 'model/user.dart';
import 'screen/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TodoModel()),
          ChangeNotifierProvider(create: (context) => UserModel()),
          ChangeNotifierProvider(create: (context) => MessageModel()),
        ],
        child: MaterialApp(
          title: 'かばっぷ',
          theme: appTheme,
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/': (context) => TopPage(),
            '/login': (context) => MyLogin(),
            '/todoList': (context) => TodoList(),
            '/todoEdit': (context) => TodoEdit(),
          },
        )
    );
  }
}

