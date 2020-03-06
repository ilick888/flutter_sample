import 'package:example_app/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoEdit extends StatelessWidget {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context){
    var catalog = Provider.of<TodoModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('TodoEdit')),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              inputText(),
              RaisedButton(
                child: Icon(Icons.remove),
                color: Colors.blue,
                onPressed: (){
                  Todo todo = new Todo(title: textController.text);
                  Navigator.of(context).pop();
                  catalog.createRecord(todo);
                },
              ),
            ]
        ),
      ),
    );
  }

  Widget inputText(){
    return TextField(
      controller: textController,
    );
  }
}