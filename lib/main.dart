import 'package:example_app/locater.dart';
import 'package:example_app/screen/todoEdit.dart';
import 'package:example_app/screen/todolist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'common/theme.dart';
import 'model/todo.dart';
import 'screen/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TodoModel()),
        ],
        child: MaterialApp(
          title: 'Provider Demo',
          theme: appTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => MyLogin(),
            '/todoList': (context) => TodoList(),
            '/todoEdit': (context) => TodoEdit(),
          },
        )
    );
  }
}
