
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/locater.dart';
import 'package:flutter/material.dart';

import 'api.dart';

class Todo {
  String id;
  String title;
  bool completed;

  Todo({@required this.title, this.completed = false});

  Todo.fromMap(Map snapshot,String id) :
        id = id ?? '',
        title = snapshot['title'] ?? '',
        completed = snapshot['complated'] ?? '';

  toJson() {
    return {
      "title": title,
      "completed": completed,
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
    });
  }

  Stream getAll(){
    return databaseReference.snapshots();
  }

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Todo> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Todo.fromMap(doc.data, doc.documentID) ;
  }

  Future removeTodo(String id) async{
    await _api.removeDocument(id) ;
    return ;
  }

}
