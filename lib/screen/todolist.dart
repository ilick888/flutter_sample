
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
        ));
  }
}

class Body extends StatelessWidget {

  var catalog = TodoModel();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoModel>(
      builder: (context, todos, child) {
        return StreamBuilder(
          stream: todos.fetchProductsAsStream(),
          builder: (context, snapshot){
            if(snapshot.data == null){
              return Center( child: CircularProgressIndicator());
            }
            return lv(snapshot.data.documents);
          },
        );
      },
    );
  }

  List<Widget> tl (List<DocumentSnapshot> todo){
    return todo.map((f) => Card(child:ListTile(title : Text(f['title']), subtitle: Text(f['completed'].toString()),))).toList();
  }

  Widget lv(List<DocumentSnapshot> todo) {
    return ListView(
      children: tl(todo),
    );
  }

}


