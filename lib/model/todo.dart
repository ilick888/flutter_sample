
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/locater.dart';
import 'package:flutter/material.dart';

import 'api.dart';

class Todo {
  String id;
  String title;
  bool completed;
  DateTime createdAt;

  Todo({@required this.title, this.completed = false, this.createdAt});

  Todo.fromMap(Map snapshot,String id) :
        id = id ?? '',
        title = snapshot['title'] ?? '',
        completed = snapshot['completed'] ?? false,
        createdAt = snapshot['createdAt'].toDate() ?? null;

  toJson() {
    return {
      "title": title,
      "completed": completed,
      "createdAt": createdAt,
    };
  }

}

class TodoModel extends ChangeNotifier{

  Api _api = locator<Api>();
  List<Todo> todos;

  final databaseReference = Firestore.instance.collection('todo');


  void createRecord(todo) async {
    await databaseReference.document().setData({
      'title' : todo.title,
      'completed' : todo.completed,
      'createdAt' : DateTime.now(),
    });
  }
  void createRecord2(Todo todo) async {
    todo.createdAt = DateTime.now();
    await _api.addDocument(todo.toJson());
  }

  Stream<QuerySnapshot> fetchTodosAsStreamOrderByCreatedAt() {
    return _api.streamDataCollectionOrderByCreatedAt();
  }

  Future<Todo> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Todo.fromMap(doc.data, doc.documentID) ;
  }

  Future removeTodo(String id) async{
    await _api.removeDocument(id) ;
    return ;
  }

  Future updateTodo(Todo data,String id) async{
    data.completed = !data.completed;
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

}
