
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'api.dart';

class Message {
  String id;
  String to;
  String from;
  List member;
  String message;
  DateTime createdAt;

  Message({this.from, this.to, this.message, this.createdAt, this.member});

  Message.fromMap(Map snapshot,String id) :
        id = id ?? '',
        to = snapshot['to'] ?? '',
        from = snapshot['from'] ?? '',
        member = snapshot['member'],
        message = snapshot['message'],
        createdAt = snapshot['createdAt'].toDate() ?? null;

  toJson() {
    return {
      "to": to,
      "from": from,
      "member" : [to,from],
      "message" : message,
      "createdAt": createdAt,
    };
  }
}

class MessageModel extends ChangeNotifier{
  Api _api = Api('message');
  List<Message> messages;

  void createRecord(Message message) async {
    message.createdAt = DateTime.now();
    await _api.addDocument(message.toJson());
    ChangeNotifier();
  }

  Stream<QuerySnapshot> fetchMessagesAsStreamOrderByCreatedAt(String to, String from) {
    return _api.getMessageCollectionWhereOrderByCreatedAt([to,from]);
  }

  Future removeMessage(String id) async{
    await _api.removeDocument(id) ;
    return ;
  }

}