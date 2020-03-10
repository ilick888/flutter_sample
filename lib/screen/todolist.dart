import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TodoList')),
      body: Body(),
      floatingActionButton: BottomFloatButton(),
    );
  }
}

class BottomFloatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/todoEdit');
          },
        )
    );
  }
}

class Body extends StatelessWidget {
  List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoModel>(context);
    return StreamBuilder(
      stream: todoProvider.fetchTodosAsStreamOrderByCreatedAt(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.data == null){return CircularProgressIndicator();}
        todos = snapshot.data.documents.map((doc) => Todo.fromMap(doc.data, doc.documentID)).toList();
        return ListView(
            children: todos.map((f) => Card(child: 
            ListTile(
              title: Text(f.title), 
              subtitle: Text(f.createdAt.toIso8601String()),
              trailing: f.completed ? Icon(Icons.check_circle) : null,
              onTap: (){
                todoProvider.updateTodo(f, f.id);
                },
              onLongPress: (){
                Scaffold.of(context).showSnackBar(SnackBar(content: Text(f.title + ' deleted')));
                todoProvider.removeTodo(f.id);
                },
              )
            )
            ).toList());
      },
    );
  }
}
