import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/model/message.dart';
import 'package:example_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Admin extends StatelessWidget {
  final textController = TextEditingController();
  List<Message> messages;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text('管理画面')),
        body: Padding(
          child: Column(children: [
            Expanded(
                child: ChatList()),
          ]),
          padding: EdgeInsets.all(10),
          ));
  }
}

class ChatList extends StatelessWidget {
  List<Message> messages;
  List<User> users;
  var formatter = new DateFormat('M月d日 HH:mm');


  @override
  Widget build(BuildContext context) {
    final MessageModel messageModel = Provider.of<MessageModel>(context);
    var formatter = new DateFormat('M月d日 HH:mm');
    return StreamBuilder(
      stream: messageModel.fetchMessagesAsStreamOrderByCreatedAt('dummy', 'dummy'),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        messages = snapshot.data.documents
            .map((doc) => Message.fromMap(doc.data, doc.documentID))
            .toList();
        return ListView(
          reverse: true,
          children: messages
              .map((f) => Card(
              child : ListTile(
                  subtitle: Text(f.from),
                  title: Text(f.message),
                  trailing: Text(formatter.format(f.createdAt)),
                  onLongPress:(){ showDelete(context, messageModel, f); }
                    )))
              .toList(),
          );
      },
      );
  }

  Future<Widget> showDelete(context,messageModel,Message f) async{
    return                          await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text('本当に削除しますか'),
            actions: <Widget>[
              FlatButton(
                child: Text('いいえ'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
                ),
              FlatButton(
                child: Text('はい'),
                onPressed: (){
                  messageModel.removeMessage(f.id);
                  Navigator.of(context).pop();
                },
                ),

            ],
            );
        }
        );

  }
}


